#!/bin/bash

DB=/opt/ejabberd/database
DB_NAME=ejabberd


# db connection settings
sed -i "s/odbc_mysql_server_value/${MYSQLDB1_PORT_3306_TCP_ADDR}/" /opt/ejabberd/conf/ejabberd.yml
sed -i "s/odbc_mysql_database_value/${DB_NAME}/" /opt/ejabberd/conf/ejabberd.yml
sed -i "s/odbc_mysql_username_value/admin/" /opt/ejabberd/conf/ejabberd.yml
sed -i "s/odbc_mysql_password_value/${MYSQLDB1_ENV_MYSQL_PASS}/" /opt/ejabberd/conf/ejabberd.yml


DB_CHECK=$(mysqlshow -uadmin -P3306 -p$MYSQLDB1_ENV_MYSQL_PASS -h$MYSQLDB1_PORT_3306_TCP_ADDR $DB_NAME | grep -o $DB_NAME)
if [ "$DB_CHECK" == $DB_NAME ]; then
	echo '[ skip setup db ]'
else
	mysqladmin -uadmin -P3306 -p$MYSQLDB1_ENV_MYSQL_PASS -h$MYSQLDB1_PORT_3306_TCP_ADDR create $DB_NAME
	mysql -uadmin -P3306 -p$MYSQLDB1_ENV_MYSQL_PASS -h$MYSQLDB1_PORT_3306_TCP_ADDR $DB_NAME \
			< /opt/ejabberd/lib/ejabberd-14.07/priv/sql/mysql.sql

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