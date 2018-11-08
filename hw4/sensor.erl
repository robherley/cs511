-module(sensor).
-compile(export_all).
-author("Rob Herley, Aimal Wajihuddin").

sense(Watcher, ID) ->
    Measurement = rand:uniform(11), % get a rando measurement
    Sleepy = rand:uniform(10000), % sleep randomly
    timer:sleep(Sleepy), % sleep
    case Measurement of
        11 -> exit(anomalous_reading); % bad measurement, so crash
        _ -> Watcher!{ID, Measurement},
            sense(Watcher, ID)
    end.
