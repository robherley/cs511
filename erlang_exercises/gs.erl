-module(gs).
-compile(export_all).

start(InitialState, F) ->
  S = spawn(?MODULE, server_loop, [InitialState, F]).

server_loop(State, F) ->
  receive
    {From, Ref, Data, request} ->
      case catch F(State,Data) of
        {'EXIT', Reason } -> % if our server func fails
          From!{self(), Ref, error, Reason},
          server_loop(State, F);
        {NewState, Result} -> % if success, update state
          From!{self(), Ref, Result},
          server_loop(NewState, F)
      end;
    {From, Ref, inspect} -> % see the server state
      From!{self(), Ref, State},
      server_loop(State, F);
    {From, Ref, G, update} -> % update the server func 
      From!{self(), Ref, State},
      server_loop(State, G);
    stop ->
      stop
  end.