#!/usr/bin/env bash

# https://goo.gl/mdc2k7
function cpu_percent_used {
  printf %.0f $(echo "100 - $(mpstat | grep -Po 'all.* \K[^ ]+$')" | bc)
}

# https://goo.gl/NMLeIb
function mem_percent_used {
  printf %.0f $(free | grep Mem | awk '{print $3/$2 * 100}')
}

# https://goo.gl/iihlP4
function disk_percent_used {
  df -k --output=pcent /dev/sda1 | tail -n 1 | tr -d ' %'
}

# https://goo.gl/aFNhNd
function top_cpu_process {
  ps -eo pcpu,pid,ppid,user,args | sort -bnr | head -1
}

function top_cpu_process {
  ps -eo pmem,pid,ppid,user,args | sort -bnr | head -1
}

echo "Checking CPU, MEM, Disk..."
echo
echo "CPU Used: $(cpu_percent_used)%"
echo "MEM Used: $(mem_percent_used)%"
echo "DISK Used: $(disk_percent_used)%"

while (( $(cpu_percent_used) >= 90 )); do
  echo
  echo "CPU above 90%, killing off process!"
  echo $(top_cpu_process)
  kill -9 $(top_cpu_process | awk '{print $2}')
  kill -9 $(top_cpu_process | awk '{print $3}')
  sleep 2
done

while (( mem_percent_used >= 10 )); do
  echo
  echo "MEM above 90%, killing off process!"
  echo $(top_mem_process)
  kill -9 $(top_mem_process | awk '{print $2}')
  kill -9 $(top_mem_process | awk '{print $3}')
  sleep 2
done

while (( disk_percent_used >= 90 )); do
  echo
  echo "DISK above 90%, powering off server!"
  poweroff
done

echo
echo "Check Complete, Happy April Fools Day"
