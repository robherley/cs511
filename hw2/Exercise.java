/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Map;
import java.util.HashMap;
import java.util.Random;

public class Exercise {
   private ApparatusType at;
   private Map<WeightPlateSize, Integer> weight;
   private int duration;

   public Exercise(ApparatusType at, Map<WeightPlateSize, Integer> weight, int duration) {
      this.at = at;
      this.weight = weight;
      this.duration = duration;
   }

   public Map<WeightPlateSize, Integer> getWeightMap() {
      return weight;
   }

   public ApparatusType getApparatusType() {
      return at;
   }

   public int getDuration() {
      return duration;
   }

   public static Exercise generateRandom(Map<WeightPlateSize, Integer> weight) {
      Map<WeightPlateSize, Integer> reqWeights = new HashMap<WeightPlateSize, Integer>();
      Random rand = new Random();
      int totalWeight = 0;
      while (totalWeight != 0) { // Just incase our combined weight is < 1
         for (WeightPlateSize w : WeightPlateSize.values()) {
            int newWeight = rand.nextInt(10); // Possible of 0-10 per weight
            reqWeights.put(w, newWeight);
            totalWeight += newWeight;
         }
      }

      int durr = rand.nextInt(20) + 5; // Duration of 5-20 ms

      return new Exercise(ApparatusType.getRandom(), reqWeights, durr);
   }
}