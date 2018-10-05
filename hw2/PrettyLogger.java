/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class PrettyLogger {

   // We want atomic printing
   public static synchronized void logRoutine(int id, List<Exercise> rt, Boolean end) {
      String status = end ? "\u001B[42m Finished " : "\u001B[47m Started! ";
      System.out.printf("\u001B[36mClient %d\u001B[30m => \t \u001B[30m%s\u001B[0m", id, status);
      System.out.printf(" Routine with \u001B[36m%d\u001B[0m exercises.\n", rt.size());
   }

   public static synchronized void logExercise(int id, Exercise ex, Boolean end) {
      Map<WeightPlateSize, Integer> wt = ex.getWeightMap();
      String status = end ? "\u001B[45m Finished " : "\u001B[43m Started! ";
      System.out.printf("\u001B[36mClient %d\u001B[30m => \t \u001B[30m%s\u001B[0m", id, status);
      System.out.printf(" Exercise on \u001B[33m%s\u001B[0m => \u001B[32m(S: %d, M: %d, L: %d)\u001B[0m\n",
            ex.getApparatusType(), wt.get(WeightPlateSize.SMALL_3KG), wt.get(WeightPlateSize.MEDIUM_5KG),
            wt.get(WeightPlateSize.LARGE_10KG));
   }

}