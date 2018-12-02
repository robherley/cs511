byte sem = 0;
byte mutex = 0;
byte m = 0;
byte w = 0;

inline acquire(sem){
  skip;
  end:
    atomic {
      (sem > 0)
      sem--;
    }
}

inline release(sem){
  sem++;
}


active [20] proctype Man() {
  acquire(mutex);
  acquire(sem);
  acquire(sem);
  m++;
  release(mutex);
  assert (m*2 <= w);
}

active [20] proctype Woman() {
  release(sem);
  w++;
}