#!/bin/sh
#
# This script is written to help configure an axport to use as a winlink node.
# It sets AX.25 and KISS params appropriate to the given HBAUD (link baudrate)
set -ex
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then echo "Usage: $0 [tty] [axport] [1200/9600]"
  exit 1;
fi

# Init TNC (optional)
[ -z "$TNC_INIT_CMD" ] || eval "$TNC_INIT_CMD";

if [ "$3" -eq "9600" ]; then
  /usr/sbin/kissattach $1 $2 -m 256 44.168.1.1
  /usr/sbin/kissparms -p $2 -t 100 -l 10 -s 12 -r 80 -f n
  # https://github.com/wb2osz/direwolf/issues/42
  /usr/sbin/kissparms -c 1 -p $2
  echo 4      > /proc/sys/net/ax25/ax0/standard_window_size  # 2-7 (max frames)
  echo 256    > /proc/sys/net/ax25/ax0/maximum_packet_length # 1-512 (paclen)
  echo 3100   > /proc/sys/net/ax25/ax0/t1_timeout            # (Frack /1000 = seconds)
  echo 800    > /proc/sys/net/ax25/ax0/t2_timeout            # (RESPtime /1000 = seconds)
  echo 300000 > /proc/sys/net/ax25/ax0/t3_timeout            # (Check /1000 = seconds)
  echo 100000  > /proc/sys/net/ax25/ax0/idle_timeout         # (/10000(?) = seconds)
  echo 5      > /proc/sys/net/ax25/ax0/maximum_retry_count   # n
  echo 2      > /proc/sys/net/ax25/ax0/connect_mode          # 0 = None, 1 = Network, 2 = All
elif [ "$3" -eq "1200" ]; then
  /usr/sbin/kissattach $1 $2 44.168.1.1
  /usr/sbin/kissparms -p $2 -t 300 -l 10 -s 12 -r 80 -f n
  # https://github.com/wb2osz/direwolf/issues/42
  /usr/sbin/kissparms -c 1 -p $2
  echo 4      > /proc/sys/net/ax25/ax0/standard_window_size
  echo 128    > /proc/sys/net/ax25/ax0/maximum_packet_length
  echo 2000   > /proc/sys/net/ax25/ax0/t1_timeout
  echo 1000   > /proc/sys/net/ax25/ax0/t2_timeout
  echo 300000 > /proc/sys/net/ax25/ax0/t3_timeout
  echo 100000   > /proc/sys/net/ax25/ax0/idle_timeout
  echo 5      > /proc/sys/net/ax25/ax0/maximum_retry_count
  echo 2      > /proc/sys/net/ax25/ax0/connect_mode
else
  echo "Invalid HBAUD $3"
  return 1;
fi

ax25d -l &

/usr/sbin/mheardd -l -f -n 20

axlisten -cart
