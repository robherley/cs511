
/**
 * Robert Herley I pledge my honor that I have abided by the Stevens Honor
 * System.
 */

import java.util.ArrayList;
import java.util.List;

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

      /**
       * Given a list of intervals, find all the primes [start, end) of each interval
       * 
       * @param intervals intervals of primes to check
       * @return list of all the primes in the given intervals
       * @throws InterruptedException if a thread is incorrectly interrupted
       */
      public static List<Integer> lprimes(List<Integer[]> intervals) throws InterruptedException {
            List<Integer> primes = new ArrayList<Integer>();
            List<Thread> threads = new ArrayList<Thread>(intervals.size());
            List<PrimeFinder> finders = new ArrayList<PrimeFinder>(threads.size());
            for (Integer[] interval : intervals) {
                  PrimeFinder newFinder = new PrimeFinder(interval[0], interval[1]);
                  finders.add(newFinder);
                  Thread newThread = new Thread(newFinder);
                  threads.add(newThread);
                  newThread.start();
            }
            // Join the threads
            for (Thread thread : threads) {
                  thread.join();
            }
            // Get the primes from the finders
            for (PrimeFinder finder : finders) {
                  primes.addAll(finder.getPrimesList());
            }
            return primes;
      }

      public static void main(String[] args) {
            try {
                  List<Integer[]> intervals = parseArgs(args);
                  List<Integer> finalPrimes = lprimes(intervals);
                  System.out.println(finalPrimes);
            } catch (Exception e) {
                  System.out.printf("Error: %s\n\n", e.getMessage());
                  System.out.println(String.join("\n", "Usage: java AssignmentOne [g1, d1, . . . , gk, dk]",
                              "Where the following conditions hold:", "\t1) The list of arguments is increasing",
                              "\t2) Each number is greater or equal to 2"));
            }
      }
}