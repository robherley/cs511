public class AssignmentOne {

   private static int[] parseArgs(String[] args) throws Exception {
      if (args.length < 2) {
         throw new Exception("You must supply at least two arguments.");
      }
      int[] newArgs = new int[args.length];
      for (int i = 0; i < args.length; i++) {
         try {
            int n = Integer.parseInt(args[i]);
            if (n < 2)
               throw new Exception("The argument at index '" + i + "' is less than 2.");
            if (i > 0 && newArgs[i - 1] > n)
               throw new Exception("The list of arguments must be an increasing sequence.");
            newArgs[i] = n;
         } catch (NumberFormatException e) {
            throw new Exception("The argument at index '" + i + "' is not a valid number.");
         } catch (Exception e) {
            throw new Exception(e.getMessage());
         }
      }
      return newArgs;
   }

   public static void main(String[] args) {
      try {
         int[] newArgs = parseArgs(args);
         for (int arg : newArgs) {
            System.out.println(arg);
         }
      } catch (Exception e) {
         System.out.printf("Error: %s\n\n", e.getMessage());
         System.out.println(String.join("\n", "Usage: java AssignmentOne [g1, d1, . . . , gk, dk]",
               "Where the following conditions hold:", "\t1) The list of arguments is increasing",
               "\t2) Each number is greater or equal to 2"));
      }
   }
}