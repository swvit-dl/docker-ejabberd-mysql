#!/bin/bash

DB=/opt/ejabberd/database

if [ "$(ls -A $DB)" ]; then
	true
else
	/opt/ejabberd/bin/ejabberdctl start
	sleep 5

	echo 'add new user admin@localhost (password: 1234567)'
	/opt/ejabberd/bin/ejabberdctl register admin localhost 1234567

	echo 'Stop ejabberd server ...'
	/opt/ejabberd/bin/ejabberdctl stop

	echo 'Waiting 15 seconds for shutdown node'
	sleep 15
fi

echo 'ejabberd live'
/opt/ejabberd/bin/ejabberdctl live