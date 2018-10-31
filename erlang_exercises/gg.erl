-module(gg).
-compile(export_all).

start() ->
   spawn(fun server /0).


servlet(From, Ref, N) ->
receive
   {From,Ref,Guess} -> 
      case Guess of
         N -> From!{gotIt};
         _ -> From!{tryAgain}, servlet(From, Ref, N)
      end
end.

server() ->
   receive
      {From, Ref, start} -> 
         N = rand:uniform(10),
         Serv = spawn(?MODULE, servlet, [From, Ref, N]),
         From!{Serv}
   end.

guessing(Servlet, Ref) ->
   Guess = rand:uniform(10),
   Servlet!{self(),Ref,Guess},
   receive
      {gotIt} -> io:format("You guessed correctly!~n");
      {tryAgain} -> io:format("Wrong answer, try again!~n"), guessing(Servlet, Ref)
   end.

client(S) ->
   R = make_ref(),
   S!{self(), R, start},
   receive
      {Servlet} -> guessing(Servlet, R)
   end.
   
