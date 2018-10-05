/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

public class Assignment2 {
   public static void main(String[] args) {
      Thread thread = new Thread(new Gym());
      thread.start();
      try {
         thread.join();
      } catch (InterruptedException e) {
         e.printStackTrace();
      }
   }
}