-module(watcher).
-compile(export_all).
-author("Rob Herley, Aimal Wajihuddin").

setup_loop(N, Watchers) -> 
	io:format("Starting ~w sensors with ~w watchers\n", [N, Watchers]).

start() ->
	{ok, [N]} = io:fread("enter number of sensors> ", "~d"),
	if N =< 1 ->
			io:fwrite("setup: range must be at least 2~n", []);
		true ->
			Watchers = round(math:ceil(N / 10)), 
			setup_loop(N, Watchers)
	end.