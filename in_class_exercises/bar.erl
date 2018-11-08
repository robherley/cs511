-module(bar).
-compile(export_all).

start(W,M) ->
    S=spawn(?MODULE,server,[0,0]),
    [spawn(?MODULE,woman,[S]) || _ <- lists:seq(1,W)],
    [spawn(?MODULE,man,[S]) || _ <- lists:seq(1,M)].

woman(S) ->
    S!{self(),woman}.

man(S) ->
    Ref=make_ref(),
    S!{self(),Ref,man},
    receive {S,Ref,ok} ->
        ok
end.

server(Women) ->
    receive
        {_From,woman} ->
            server(Women+1);
        {From,Ref,man} when Women > 1 ->
            From!{self(),Ref,ok},
            server(Women-2)
end.