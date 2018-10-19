-module(semaphore).
-compile(export_all).

make_semaphore(Permits) ->
   spawn(?MODULE, semaphore, [Permits]).

semaphore(Permits) ->
   case Permits of 
      0 -> 
         receive
            {From, release} -> 
               From!{self(), ok},
               semaphore(1)
         end;
      N -> 
         receive
            {From, release} -> 
               From!{self(), ok},
               semaphore(N + 1);
            {From, acquire} -> 
               From!{self(), ok},
               semaphore(N -1)
         end
   end.

clientOne(S) ->
   io:format("Client One~n"),
   S!{self(), acquire},
   receive
      {_, ok} -> ok
   end.

clientTwo(S) ->
   io:format("Client Two~n"),
   S!{self(), acquire},
   receive
      {_, ok} -> ok
   end.