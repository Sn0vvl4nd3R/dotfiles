#!/bin/sh

mullvad status 2>/dev/null | awk '
/Connected/ {connected=1}
/Relay:/ && connected {
  relay=$2
  n=split(relay,a,"-")
  if (n>=2) {
    printf "%s-%s\n", toupper(a[1]), toupper(a[2])
  } else {
    print "CONNECTED"
  }
  exit
}
END {
  if (!connected) print "OFF"
}'
