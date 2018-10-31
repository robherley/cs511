-module(bar_igl).
-compile(export_all).

start(M) ->
   S = spawn(?MODULE, server, [0,false]),
   [spawn(?MODULE, man, [S]) || _ <- lists:seq(1,M)],
   S.

server(Women, ItGotLate) ->
   receive
      {_From, itGotLate} ->
         server(Women, true);
      {_From, woman} -> 
         server(Women + 1, ItGotLate);
      {From, Ref, man} when Women > 1 orelse ItGotLate -> 
         From!{self(), Ref, enter},
         server(Women - 2, ItGotLate)
   end.

woman(S) ->
   S!{self(), woman},
   io:format("Woman ~w entered.~n", [self()]).

man(S) -> 
   R = make_ref(),
   S!{self(), R, man},
   receive
      {S, R, enter} -> ok
   end,
   io:format("Man ~w entered.~n", [self()]).

itsLate(S) ->
   S!{self(), itGotLate}.