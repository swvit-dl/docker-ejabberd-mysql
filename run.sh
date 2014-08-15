#!/bin/bash

docker run -t -d -p 5222:5222 -p 5269:5269 -p 5280:5280 --link mysqldb1:mysqldb1 \
	-v /opt/docker/ejabberd_database:/opt/ejabberd/database swvitaliy/ejabberd