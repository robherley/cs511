-module(ms). 
-compile(export_all).

meta_search() -> 
  receive
  {request,From,Ref,Query} -> 
    spawn(?MODULE, meta_search_delegate, [From,Ref,Query]), 
    meta_search()
  end.

meta_search_delegate(From,Ref,Query) -> 
  whereis(googlePid)!{Query,self()}, 
  whereis(bingPid)!{Query,self()}, 
  whereis(yahooPid)!{Query,self()}, 
  receive
    {_Engine1, Result1} -> 
      receive
        {_Engine2, Result2} -> 
          receive
            {_Engine3, Result3} -> From!{response,Ref,lists:concat([Result1,Result2,Result3])}
          end 
      end
  end.

client(S, Query) -> 
  Ref = make_ref(),
  S!{request, self(), Ref, Query},
  receive
    {response, Ref, Responses} -> 
      io:format("Recieved Responses:"),
      lists:map(fun (X) -> io:format("~w\n", [X]) end, Responses)
  end.