byte permits;

inline acquire(sem){
  atomic {
    (sem > 0)
    sem--;
  }
}

inline release(sem){
  sem++;
}

proctype P(){
  printf("A\n");
  release(permits);
}

proctype Q(){
  acquire(permits);
  printf("B\n");
}

init {
  permits = 0;
  run P();
  run Q();
}