/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

import hw2.ApparatusType;
import hw2.Client;
import hw2.WeightPlateSize;

public class Gym implements Runnable {
   private static final int GYM_SIZE = 30; // Number of Thread Pools
   private static final int GYM_REGISTERED_CLIENTS = 10000; // Reg Clients
   private Map<WeightPlateSize, Integer> noOfWeightPlates; // Plate Map
   private Set<Integer> clients; // Used to Generate Client ID's
   private ExecutorService executor;

   public Semaphore weightMutex; // Only one person can pickup at a time
   public Map<WeightPlateSize, Semaphore> weightSems; // Weight protection map
   public Map<ApparatusType, Semaphore> apparatusSems; // App protection map

   public Gym() {
      // Initialize noOfWeightPlates
      noOfWeightPlates = new HashMap<WeightPlateSize, Integer>();
      noOfWeightPlates.put(WeightPlateSize.SMALL_3KG, 110);
      noOfWeightPlates.put(WeightPlateSize.MEDIUM_5KG, 90);
      noOfWeightPlates.put(WeightPlateSize.LARGE_10KG, 75);

      // Initialize Semaphore for accessing weight map
      weightMutex = new Semaphore(1);

      // Initialize Weight Semaphore Map
      for (WeightPlateSize weight : WeightPlateSize.values()) {
         // Add a semaphore with the number of weights for each weight
         weightSems.put(weight, new Semaphore(noOfWeightPlates.get(weight)));
      }

      // Initialize Apparatus Semaphore Map
      for (ApparatusType app : ApparatusType.values()) {
         // Add a semaphore with 5 permits for each apparatus
         apparatusSems.put(app, new Semaphore(5));
      }
   }

   public void run() {
      executor = Executors.newFixedThreadPool(GYM_SIZE);
      for (int i = 0; i < GYM_REGISTERED_CLIENTS; i++) {
         executor.execute(Client.generateRandom(i, noOfWeightPlates));
      }
      executor.shutdown();
   }
}