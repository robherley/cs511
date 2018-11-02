-module(b).
-compile(export_all).

startBarrier(N) ->
  Pid = spawn(fun() -> coordinator(N, N, []) end),
  register(coordinator, Pid).

start() ->
  startBarrier(3),
  spawn(?MODULE, client, ["a~n", "b~n"]),
  spawn(?MODULE, client, ["c~n", "d~n"]),
  spawn(?MODULE, client, ["e~n", "f~n"]).

coordinator(0, NumAllowed, TList) -> %% all in, notify
  lists:foreach(fun({Thread, Ref}) -> Thread!{self(), Ref, ok} end, TList),
  coordinator(NumAllowed, NumAllowed, []);

coordinator(Counter, NumAllowed, TList) when Counter > 0 -> %% waiting for more threads
  receive
    {Pid, Ref, arrived} -> coordinator(Counter-1, NumAllowed, [{Pid, Ref} | TList])
  end.

client(Str1, Str2) ->
  io:format(Str1),
  Ref = make_ref(),
  C = whereis(coordinator),
  coordinator!{self(), Ref, arrived},
  receive 
    {C, Ref, ok} -> ok
  end,
  io:format(Str2).