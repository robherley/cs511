-module(sensor).
-compile(export_all).
-author("Rob Herley, Aimal Wajihuddin").

sense(Watcher, ID) ->
    Measurement = rand:uniform(11),
    Sleep_time = rand:uniform(10000),
    timer:sleep(Sleep_time),
    case Measurement of
        11 -> exit(anomalous_reading);
        _ -> Watcher!{ID, Measurement}
    end,
    sense(Watcher, ID).