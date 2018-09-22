/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;

public class Gym {
   private static final int GYM_SIZE = 30;
   private static final int GYM_REGISTERED_CLIENTS = 10000;
   private Map<WeightPlateSize, Integer> noOfWeightPlates;

   private Set<Integer> clients; // for generating fresh client ids
   private ExecutorService executor;

   // put other semaphores here

}