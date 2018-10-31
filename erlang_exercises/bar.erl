-module(bar).
-compile(export_all).

start(M, W) ->
   S = spawn(?MODULE, server, [0,0]),
   [spawn(?MODULE, woman, [S]) || _ <- lists:seq(1,W)],
   [spawn(?MODULE, man, [S]) || _ <- lists:seq(1,M)].

server(Women) ->
   receive
      {_From, woman} -> 
         server(Women + 1);
      {From, Ref, man} when Women > 1 -> 
         From!{self(), Ref, enter},
         server(Women -2)
   end.

woman(S) ->
   S!{self(), woman}.

man(S) -> 
   R = make_ref(),
   S!{self(), R, man},
   receive
      {S, R, enter} -> ok
   end.
