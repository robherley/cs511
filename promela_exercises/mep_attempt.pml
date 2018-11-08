bool wantP = false;
bool wantQ = false;

active proctype P() {
  do
    :: 
    // non-crit
    wantP = true;
    !wantQ;
    // crit
    wantP = false;
    // non-crit
  od
}

active proctype Q() {
  do
    :: 
    // non-crit
    wantQ = true;
    !wantP;
    // crit
    wantQ = false;
    // non-crit
  od
}