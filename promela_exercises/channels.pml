chan request = [1] of { byte, byte }
mtype { ack };
chan reply[2] = [1] of { mtype }

active proctype Server() {
  byte n;
  byte id;
  do
    :: request?n ->
      printf("%d\n",n);
      reply[id]!ack
  od
}

active proctype Client1() {
  request!3
  reply[0]?ack;
  printf("Client 1 got ack\n")
}

active proctype Client2() {
  request!5
  reply[1]?ack;
  printf("Client 2 got ack\n")
}