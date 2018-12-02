byte turn;
bool flags[3];

proctype P() {
  // printf("PID: %u\n", _pid);
  byte id = _pid - 1;
  byte left;
  if 
    :: (id == 0) ->
      left = 2;
    :: (id > 0) -> 
      left = (id-1) % 3;
  fi
  byte right = (id+1) % 3;
  flags[id] = true;
  do 
    :: !(flags[left] && flags[right]) -> break
    :: else ->
      if
        :: turn == left ->
          flags[id] = false;
          (turn == id);
          flags[id] = true;
        :: true ->
      fi
  od
}

init {
  turn = 0;
  byte i;
  for(i:0..2) {
    flags[i] = false;
  }
  atomic {
    for (i:0..2){
      run P();
    }
  }
}