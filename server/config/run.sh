#!/usr/bin/env bash
ulimit -n 65535
if ps aux | grep -w "./ShareMemory" | grep -v grep >/dev/null 2>&1;then
  echo " ShareMemory  is running !!!!!!"
else
  ###### start billing ######
  cd /home/billing
  ./billing & >/dev/null 2>&1
  echo " start billing ......"

  sleep 30
  echo " billing started completely !!!!!!"
  ###### start ShareMemory ######

  cd /home/tlbb/Server/
  ./shm clear >/dev/null 2>&1
  rm -rf exit.cmd quitserver.cmd
  ./shm start >/dev/null 2>&1
  echo " start ShareMemory ......"

  sleep 30
  echo " ShareMemory started completely !!!!!!"

  ###### start World ######
  cd /home/tlbb/Server/
  ./World >/dev/null 2>&1 &
  echo " start World ......"
  sleep 5
  echo " World started completely !!!!!!"

  ###### start Login ######
  ./Login >/dev/null 2>&1 &
  echo " start Login ......"
  sleep 1
  echo " Login started completely !!!!!!"

  ###### start Server ######
  cd /home/tlbb/Server/
    ./Server >/dev/null 2>&1 &
  echo " start Server ......"

  sleep 60
  echo " Server started completely !!!!!!"
  exit
fi