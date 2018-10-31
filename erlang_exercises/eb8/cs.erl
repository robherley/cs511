-module(cs).
-compile(export_all).

concat(Str) ->
   receive
      {start} -> io:format("Starting Str Server~n"), concat(Str);
      {add, NewStr} -> concat(Str ++ NewStr);
      {done, From} -> From!{Str}
   end.

client(Arr) ->
   S = spawn(?MODULE, concat, [""]),
   S!{start},
   lists:foreach(fun (Str) -> S!{add, Str} end, Arr),
   S!{done, self()},
   receive
      { Final } -> io:format("Final String: ~s~n", [Final])
   end.
