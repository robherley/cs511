/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Random;

public class Client implements Runnable {
   private int id; // unique client id
   private List<Exercise> routine; // list of exercises

   public Client(int id) {
      this.id = id;
      routine = new ArrayList<Exercise>();
   };

   public void addExercise(Exercise e) {
      routine.add(e);
   };

   public static Client generateRandom(int id, Map<WeightPlateSize, Integer> noOfWeightPlates) {
      Client client = new Client(id);
      Random rand = new Random();
      int exercises = rand.nextInt(5) + 15; // We want anything 15-20
      for (int i = 0; i < exercises; i++) {
         // I don't know why we need to pass in the weight map...
         // Imma do it anyway bc it's in the UML
         client.addExercise(Exercise.generateRandom(noOfWeightPlates));
      }
      return client;
   };

   public void prettyLog(Exercise ex) {
      System.out.printf("|Client %i| %s ", id, ex.getApparatusType());
      Map<WeightPlateSize, Integer> wt = ex.getWeightMap();
      System.out.printf("=> (S: %i, M: %i, L: %i)\n", wt.get(WeightPlateSize.SMALL_3KG),
            wt.get(WeightPlateSize.MEDIUM_5KG), wt.get(WeightPlateSize.LARGE_10KG));
   }

   public void run() {
      for (Exercise ex : routine) {
         prettyLog(ex);

         // First, we attempt to grab weights (only one client at a time)
         try {
            Gym.weightMutex.acquire();
         } catch (InterruptedException e) {
            e.printStackTrace();
         }

         // Then, we try to get all of our required weights
         Map<WeightPlateSize, Integer> wt = ex.getWeightMap();

         // For each weight size, try to acquire our required weights
         for (WeightPlateSize size : WeightPlateSize.values()) {
            for (int i = 0; i < wt.get(size); i++) {
               try {
                  Gym.weightSems.get(size).acquire();
               } catch (InterruptedException e) {
                  e.printStackTrace();
               }
            }
         }

         // Now we finished getting our weights
         Gym.weightMutex.release();

         // Let's try working on out on our machine
         ApparatusType app = ex.getApparatusType();
         try {
            Gym.apparatusSems.get(app).acquire();
         } catch (InterruptedException e) {
            e.printStackTrace();
         }

         // Let's workout
         try {
            Thread.sleep(ex.getDuration());
         } catch (InterruptedException e) {
            e.printStackTrace();
         }

         // We're done working out, let someone else use the machine
         Gym.apparatusSems.get(app).release();

         // We're nice people so lets re-rack our weights
         for (WeightPlateSize size : WeightPlateSize.values()) {
            for (int i = 0; i < wt.get(size); i++) {
               Gym.weightSems.get(size).release();
            }
         }

         System.out.printf("|Client %i| Finished Workout ", id);
      }
   }
}