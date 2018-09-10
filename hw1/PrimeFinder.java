
/**
 * Robert Herley & Aimal Wajihuddin
 * We pledge our honor that we have abided by the Stevens Honor System.
 */


import java.util.ArrayList;
import java.util.List;

public class PrimeFinder implements Runnable {
   private Integer start; // Start of interval
   private Integer end; // End of interval
   private List<Integer> primes; // List of primes in interval

   /**
    * Constructor for PrimeFinder
    * 
    * @param startNum start of the interval
    * @param endNum   end of the interval
    */
   PrimeFinder(Integer startNum, Integer endNum) {
      start = startNum;
      end = endNum;
      primes = new ArrayList<Integer>();
   }

   /**
    * Gets the list of primes in the interval
    *
    * @return values of the attribute primes
    */
   public List<Integer> getPrimesList() {
      return primes;
   }

   /**
    * Determines whether its argument is prime or not
    * 
    * @param n
    * @return true if prime, false if not
    */
   public Boolean isPrime(int n) {
      if (n != 2 && (n % 2) == 0)
         return false;
      for (int i = 3; i * i <= n; i += 2)
         if (n % i == 0)
            return false;
      return true;
   }

   /**
    * Adds all primes in [this.start,this.end) to the attribute primes
    */
   public void run() {
      for (int i = start; i < end; i++)
         if (isPrime(i))
            primes.add(i);
   }
}