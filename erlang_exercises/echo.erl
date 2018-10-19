-module(echo).

-compile(export_all).

echo() ->
    receive
      {From, Msg} -> From ! {self(), Msg}, echo();
      stop -> stop
    end.

client(S, M) ->
    S ! {self(), 1},
    io:format("Client ~w sent ~w~n", [self(), M]),
    receive
      {S, M} ->
	  io:format("Client ~w got back 1~w ~n", [self(), M])
    end.

start() ->
    S = spawn(?MODULE, echo, []),
    spawn(?MODULE, client, [S, 1]),
    spawn(?MODULE, client, [S, 2]).
