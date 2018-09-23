/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.List;
import java.util.Map;

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
         client.addExercise(Exercise.generateRandom(noOfWeightPlates));
      }
      return client;
   };

   public void run() {
      for (Exercise exercise : routine) {
         // do the hard stuff
      }
   }
}