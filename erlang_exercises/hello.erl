-module(hello).

-compile(export_all).

hello_world() -> io:fwrite("hello, world\n").
