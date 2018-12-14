-module(crlea).
-compile(export_all).
-author("Rob Herley, Aimal Wajihuddin").

% simple helper to get an atom
map_n(Num) ->
  list_to_atom("node_" ++ integer_to_list(Num)).

% creates a node in the ring and give the atom mapped to the next node pid
spawn_node(I, IDs, Len) -> 
  MyNum = lists:nth(I, IDs),
  case I of % i wish erlang had ternaries
    Len -> % last node in ring
      Next = map_n(lists:nth(1, IDs));
    _ -> % everything else
      Next = map_n(lists:nth((I + 1), IDs))
  end,
  io:format("\e[33m[Node ~w]\e[0m: \e[32mStarted\e[0m (Next: ~w)\n", [MyNum, Next]),
  PID = spawn(?MODULE, start_node, [MyNum, Next]),
  register(map_n(MyNum), PID), % register our pid so other nodes can find us
  case I of % pls ternaries 
    Len ->
      ok;
    _ -> 
      spawn_node(I+1, IDs, Len)
  end.

% simple helper to ensure our node "connects" with the next process
start_node(MyNum, Next) ->
  try Next!{ elect, MyNum } of 
    _ -> 
      node_loop(MyNum, Next)
  catch 
    error:badarg ->
      % incase our node starts before the next one
      start_node(MyNum, Next)
  end.

% our main looping process for cr-lea
node_loop(MyNum, Next) ->
  receive
    { elect, N } when N == MyNum -> 
      io:format("\e[33m[Node ~w]\e[0m: \e[34mI am the leader.\e[0m\n", [MyNum]),
      Next!{ leader, MyNum },
      node_loop(MyNum, Next); % wait to go all around
    { elect, N } when N > MyNum ->
      Next!{ elect, N },
      node_loop(MyNum, Next);
    { leader, N } when N /= MyNum  -> 
      io:format("\e[33m[Node ~w]\e[0m: I know ~w is the leader.\n", [MyNum, N]),
      Next!{ leader, N };
    { leader, N } when N == MyNum -> 
      finished % we went all the way around
  end.

start(N) -> 
  % gen shuffled seq 1 -> N
  % src: https://stackoverflow.com/questions/8817171/shuffling-elements-in-a-list-randomly-re-arrange-list-elements#8820501
  IDs = [X || { _, X } <- lists:sort([{ rand:uniform(), Y } || Y <- lists:seq(1,N)])],
  io:format("\e[34mID List\e[0m: ~w\n", [IDs]),
  spawn_node(1, IDs, length(IDs)).
  
  