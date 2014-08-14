#!/bin/bash

/opt/ejabberd/bin/ejabberdctl start
sleep 5
echo 'add new user admin@localhost (password: 1234567)'
/opt/ejabberd/bin/ejabberdctl register admin localhost 1234567
echo 'ejabberdctl stop'
pkill epmd
sleep 5
echo 'check ejabberd'
ps ax | grep ejabberd
echo 'ejabberd live'
/opt/ejabberd/bin/ejabberdctl live