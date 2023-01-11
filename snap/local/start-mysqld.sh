#!/bin/bash

export CONFIG_DIR="${SNAP_COMMON}/mysql"
if [ ! -f "${CONFIG_DIR}/initialized" ]; then
        $SNAP/usr/sbin/mysqld --initialize
        echo "configuration folder ${CONFIG_DIR} does not exist."
        echo "copying default config to ${CONFIG_DIR}"
        cp -r $SNAP/etc/mysql $SNAP_COMMON
        chown -R snap_daemon:root $CONFIG_DIR
	chown -R snap_daemon:root $SNAP_DATA/var
        sed -i "s:/var/run/mysqld/mysqld.sock:$CONFIG_DIR/mysqld.sock:g" $CONFIG_DIR/mysql.conf.d/mysqld.cnf
        sed -i "s:# sock:sock:g" $CONFIG_DIR/mysql.conf.d/mysqld.cnf
        sed -i "s: mysql: snap_daemon:g" $CONFIG_DIR/mysql.conf.d/mysqld.cnf
	touch $CONFIG_DIR/initialized
fi

$SNAP/usr/bin/setpriv --clear-groups --reuid snap_daemon \
  --regid snap_daemon -- $SNAP/usr/sbin/mysqld --defaults-file=$CONFIG_DIR/mysql.conf.d/mysqld.cnf
