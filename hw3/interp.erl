-module(interp).
-export([scanAndParse/1,runFile/1,runStr/1]).
-include("types.hrl").

loop(InFile,Acc) ->
    case io:request(InFile,{get_until,prompt,lexer,token,[1]}) of
        {ok,Token,_EndLine} ->
            loop(InFile,Acc ++ [Token]);
        {error,token} ->
            exit(scanning_error);
        {eof,_} ->
            Acc
    end.

scanAndParse(FileName) ->
    {ok, InFile} = file:open(FileName, [read]),
    Acc = loop(InFile,[]),
    file:close(InFile),
    {Result, AST} = parser:parse(Acc),
    case Result of 
	ok -> AST;
	_ -> io:format("Parse error~n")
    end.


-spec runFile(string()) -> valType().
runFile(FileName) ->
    valueOf(scanAndParse(FileName),env:new()).

scanAndParseString(String) ->
    {_ResultL, TKs, _L} = lexer:string(String),
    parser:parse(TKs).

-spec runStr(string()) -> valType().
runStr(String) ->
    {Result, AST} = scanAndParseString(String),
    case Result of 
    	ok -> valueOf(AST,env:new());
    	_ -> io:format("Parse error~n")
    end.


-spec numVal2Num(numValType()) -> integer().
numVal2Num({num, N}) ->
    N.

-spec boolVal2Bool(boolValType()) -> boolean().
boolVal2Bool({bool, B}) ->
    B.

-spec valueOf(expType(),envType()) -> valType().
valueOf({ numExp, {num, _, N}}, _Env) ->
    {num, N};
valueOf({ boolExp, {bool, _, B}}, _Env) ->
    {bool, B};
valueOf({ idExp, {id, _, Id} }, Env) ->
    env:lookup(Env, Id);
valueOf({ diffExp, Left, Right }, Env) -> 
    case {valueOf(Left, Env), valueOf(Right, Env)} of
        {{ num, Num1 }, { num, Num2 }} -> {num, Num1 - Num2};
        _ -> io:format("Error: valueOf(diffExp): both expressions must be numExp~n")
    end;
valueOf({ plusExp, Left, Right }, Env) -> 
    case {valueOf(Left, Env), valueOf(Right, Env)} of
        {{ num, Num1 }, { num, Num2 }} -> {num, Num1 + Num2};
        _ -> io:format("Error: valueOf(plusExp): both expressions must be numExp~n")
    end;
valueOf({ isZeroExp, Exp }, Env) -> 
    case valueOf(Exp, Env) of
        { num, Num } -> {bool, Num == 0};
        _ -> io:format("Error: valueOf(isZeroExp): expression must be numExp~n")
    end;
valueOf({ ifThenElseExp, Bool, Then, Else }, Env) -> 
    case valueOf(Bool, Env) of
        { bool, true } -> valueOf(Then, Env);
        { bool, false } -> valueOf(Else, Env);
        _ -> io:format("Error: valueOf(ifThenElseExp): first expression must be a boolean~n")
    end;
valueOf({ letExp, {id, _, Var}, Exp, Body }, Env) -> 
    valueOf(Body, env:add(Env, Var, valueOf(Exp, Env))).
% valueOf({ procExp, {id, _, Var}, Exp, Body }, Env) -> 
%     valueOf(Body, env:add(Env, Var, valueOf(Exp, Env))).

