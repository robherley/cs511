/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Random;

public enum WeightPlateSize {
   SMALL_3KG, MEDIUM_5KG, LARGE_10KG;

   private static final WeightPlateSize[] WEIGHTS = values();
   private static final int NUM_WEIGHTS = WEIGHTS.length;
   private static final Random RANDOM = new Random();

   public static WeightPlateSize getRandom() {
      return WEIGHTS[RANDOM.nextInt(NUM_WEIGHTS)];
   }
}