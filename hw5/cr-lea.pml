#define N 5 /* number of processes in the ring */
#define L 10 /* size of buffer (>= 2*N) */
byte I; /* will be used in init for assinging ids to nodes */

mtype = { next, winner }; /* symb. Msg. Names */
chan q[N] = [L] of {mtype, byte}; /* asynchronous channels */

proctype nnode (chan inp, out; byte mynumber) {
    byte nr;

    xr inp; /* channel assertion: exclusize recv access to channel in */
    xs out; /* channel assertion: exclusize send access to channel out */

    printf("MSC: %d\n", mynumber);
    out!next(mynumber);
end:    do
    :: inp?one(nr) ->
        if
        :: nr == mynumber -> 
            out!winner, nr;
            printf("I am leader (%d)\n", mynumber)
        :: nr > mynumber ->
            out!next(nr)
        :: nr < mynumber -> 
            break
        fi
    :: inp?winner, nr ->
        if
        :: nr != mynumber ->
            printf("I am node %d and I know the leader is %d\n", mynumber, nr);
            out!winner, nr;
        fi;
        break
    od
}

init {
    byte proc;
    byte Ini[6];    /* N <= 6 randomize the process numbers */
    atomic {
        I = 1; /* pick a number to be assigned 1 .. N */
        do
        :: I <= N ->
            if /* non deterministic choice */
            :: ini[0] == 0 && N >= 1 -> Ini[0] = I
            :: ini[1] == 0 && N >= 2 -> Ini[1] = I
            :: ini[2] == 0 && N >= 3 -> Ini[2] = I
            :: ini[3] == 0 && N >= 4 -> Ini[3] = I
            :: ini[4] == 0 && N >= 5 -> Ini[4] = I
            :: ini[5] == 0 && N >= 6 -> Ini[5] = I /* works for up to N = 6 */
            fi;
            I++
        :: I > N -> /* assigned all numbers 1 .. N */
            break
        od;

        /* start all nodes in the ring */
        proc = 1;
        do
        :: proc <= N ->
            run nnode (q[proc-1], q[proc%N], Ini[proc-1]);
            proc++
        :: proc > N ->
            break
        od
    }
}