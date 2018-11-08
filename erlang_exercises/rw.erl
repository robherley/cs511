-module(rw).
-compile(export_all).

reader(R,W) ->
  Ref = make_ref().
  RW!{self(), Ref, start_read},
  receive
    {RW, Ref, ok} -> read
  end,
  RW!{self(), Ref, end_read}.

loop(R,W) ->
  receive
    {From, Ref, start_read} when W=:=0 ->
      error(complete);
    {From, Ref, end_read} ->
      error(complete);
    {From, Ref, start_write} when W==0 and R==0 ->
      error(complete);
    {From, Ref, end_write} ->
      error(complete).