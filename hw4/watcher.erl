-module(watcher).
-compile(export_all).
-author("Rob Herley, Aimal Wajihuddin").

setup_loop(NumSensors, CurrSensors) when NumSensors == CurrSensors ->
	ok; % when we have sensors div by 10
setup_loop(NumSensors, CurrSensors) when NumSensors - CurrSensors =< 9 ->
	spawn(?MODULE, create_watcher, [CurrSensors, NumSensors - 1]),
    ok;
setup_loop(NumSensors, CurrSensors) when NumSensors - CurrSensors > 9 -> 
	spawn(?MODULE, create_watcher, [CurrSensors, CurrSensors + 9]),
	setup_loop(NumSensors, CurrSensors + 10).

create_watcher(Start,End) ->
	Sensors = [create_sensor(self(), ID) || ID <- lists:seq(Start,End)],
	io:format("\e[0mWatcher starting: \e[32m~w\e[0m\n",[Sensors]),
	watcher(Sensors).

create_sensor(Watcher, ID) -> 
	{ Pid, _ } = spawn_monitor(sensor, sense, [Watcher, ID]),
	{ ID, Pid }.

watcher(Sensors) ->
	receive
		{'DOWN', _, process, Pid, Reason} ->
			{SensorID, _ } = lists:keyfind(Pid, 2, Sensors),
			NewSensors = lists:append(lists:delete({SensorID, Pid}, Sensors), [create_sensor(self(), SensorID)]),
			io:format("\e[0mSensor \e[33m~w\e[0m died, reason: \e[31m~w\e[0m\nreplacing sensor \e[33m~w\e[0m with replacement sensor:\n\e[32m~w\e[0m\n", [SensorID, Reason, SensorID, NewSensors]),
			watcher(NewSensors);
		{ID, Measurement} ->
			io:format("\e[0mSensor \e[33m~w\e[0m reported measurement: \e[34m~w\e[0m\n", [ID, Measurement]),
			watcher(Sensors)
	end.
		
start() ->
	{ok, [NumSensors]} = io:fread("\e[0menter number of sensors> \e[35m", "~d"),
	if NumSensors =< 1 ->
			io:fwrite("\e[31msetup: range must be at least 2\e[0m~n", []);
		true ->
			setup_loop(NumSensors, 0)
	end.