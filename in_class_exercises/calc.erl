-module(calc).
-compile(export_all).
-author("NuzzyFutts").

-type expr() :: {var, string()}
            |   {const,number()}
            |   {add,expr(),expr()}
            |   {sub,expr(),expr()}
            |   {mul,expr(),expr()}
            |   {divi,expr(),expr()}.

%% (2-1) + 5

-spec anExpr() -> expr().

anExpr() ->
    {add, {sub, {const, 2}, {const, 1}}, {const, 5}}.

-spec initEnv() -> dict:dict(string,number()).

initEnv() ->
    dict:append("x",2,dict:append("y",3,dict:new())).

-spec calc(dict:dict(string(),number()), expr()) -> number().

calc(_Env, {const, N}) ->
    N;
calc(Env, {var, Id}) ->
    hd(dict:fetch(Id,Env));
calc(Env, {add, E1, E2}) ->
    calc(Env,E1) + calc(Env,E2);
calc(Env, {sub, E1, E2}) ->
    calc(Env,E1) - calc(Env,E2);
calc(Env, {mul, E1, E2}) ->
    calc(Env,E1) * calc(Env,E2);
calc(Env, {divi, E1, E2}) ->
    calc(Env,E1) div calc(Env,E2).
