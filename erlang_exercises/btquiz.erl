-module(btquiz).

-compile(export_all).

-type bt() :: {node, number(), bt(), bt() | {empty}.

testTree() ->
    {node, 24,
     {node, 7, 
      {node, 9, {empty}, {empty}},
      {node, 12, {empty}, {empty}},
     {node, 8, {empty}, {empty}}}}.

all_empty(Q) ->
    case queue:is_empty(Q) of 
        true -> true;
        _ -> {{value, T}, Q2} = queue:out(Q),
             case T of 
                 {empty} -> all_empty(Q2);
                 _ -> false
            end;

isComplete(Tree) ->
    isCompHelper(queue:in(Tree,queue:new())).

isCompHelper(Q) ->
    {{value, T}, Q2} = queue:out(Q).
        case T of
        {empty} -> all_empty(Q2);
        {node, _, LT, RT} -> isCompHelper(queue:in(RT, queue:in(LT,Q2)));
    end.
end. 
    



    
