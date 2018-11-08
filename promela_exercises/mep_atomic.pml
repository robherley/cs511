bool wantP = false;
bool wantQ = false;

active proctype P() {
  do
    :: 
    // non-crit
    atomic {
      !wantQ;
      wantP = true;
    }
    // crit
    wantP = false;
    // non-crit
  od
}

active proctype Q() {
  do
    :: 
    // non-crit
    atomic {
      !wantP;
      wantQ = true;
    }
    // crit
    wantQ = false;
    // non-crit
  od
}