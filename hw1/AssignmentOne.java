
/**
 * Robert Herley I pledge my honor that I have abided by the Stevens Honor
 * System.
 */

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

public class AssignmentOne {
   /**
    * Given the string array of arguments, parse them into an ArrayList of
    * intervals for the lprimes method. Also checks for proper arguments.
    * 
    * @param args string arguments for the program
    * @return ArrayList of intervals
    * @throws Exception if the arguments are invalid (> 2, increasing numbers)
    */
   private static List<Integer[]> parseArgs(String[] args) throws Exception {
      if (args.length < 2) {
         throw new Exception("You must supply at least two arguments.");
      }
      List<Integer[]> intervals = new ArrayList<Integer[]>(args.length);
      for (int i = 0; i < args.length - 1; i++) {
         try {
            Integer now = Integer.parseInt(args[i]);
            Integer next = Integer.parseInt(args[i + 1]);
            if (now < 2 || next < 2)
               throw new Exception("All arguments must be greater (or equal) to 2.");
            if (now >= next)
               throw new Exception("The list of arguments must be an increasing sequence.");
            Integer[] interval = { now, next };
            intervals.add(interval);
         } catch (NumberFormatException e) {
            throw new Exception("The argument at index '" + i + "' is not a valid number.");
         } catch (Exception e) {
            throw new Exception(e.getMessage());
         }
      }
      return intervals;
   }

   // public static List<Integer> lprimes(List<Integer[]> intervals) {
   //
   // }

   public static void main(String[] args) {
      try {
         List<Integer[]> intervals = parseArgs(args);
         for (Integer[] interval : intervals) {
            System.out.println(Arrays.toString(interval));
         }
      } catch (Exception e) {
         System.out.printf("Error: %s\n\n", e.getMessage());
         System.out.println(String.join("\n", "Usage: java AssignmentOne [g1, d1, . . . , gk, dk]",
               "Where the following conditions hold:", "\t1) The list of arguments is increasing",
               "\t2) Each number is greater or equal to 2"));
      }
   }
}