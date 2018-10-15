-module(env).
-compile(export_all).
-include("types.hrl").


-spec new() -> envType().
new() ->
   dict:new().

-spec add(envType(),atom(),valType())-> envType().
add(Env,Key,Value) ->
    dict:append(Key, Value, dict:erase(Key, Env)).

-spec lookup(envType(),atom())-> valType().
lookup(Env,Key) -> 
   lists:last(dict:fetch(Key, Env)).

