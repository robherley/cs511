/**
 * Robert Herley & Aimal Wajihuddin We pledge our honor that we have abided by
 * the Stevens Honor System.
 */
package hw2;

import java.util.Random;

public enum ApparatusType {
   LEGPRESSMACHINE, BARBELL, HACKSQUATMACHINE, LEGEXTENSIONMACHINE, LEGCURLMACHINE, LATPULLDOWNMACHINE, PECDECKMACHINE,
   CABLECROSSOVERMACHINE;

   private static final ApparatusType[] APPS = values();
   private static final int NUM_APPS = APPS.length;
   private static final Random RANDOM = new Random();

   public static ApparatusType getRandom() {
      return APPS[RANDOM.nextInt(NUM_APPS)];
   }
}