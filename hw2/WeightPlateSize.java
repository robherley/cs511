/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Random;

// Idea from https://stackoverflow.com/questions/1972392/pick-a-random-value-from-an-enum#29818452
public enum WeightPlateSize {
   SMALL_3KG, MEDIUM_5KG, LARGE_10KG;

   private static final WeightPlateSize[] WEIGHTS = values();
   private static final int NUM_WEIGHTS = WEIGHTS.length;
   private static final Random RANDOM = new Random();

   public static WeightPlateSize getRandom() {
      return WEIGHTS[RANDOM.nextInt(NUM_WEIGHTS)];
   }
}