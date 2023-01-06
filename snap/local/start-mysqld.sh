#!/bin/bash

export CONFIG_DIR="${SNAP_COMMON}/mysql"
if [ ! -f "${CONFIG_DIR}/initialized" ]; then
        $SNAP/usr/sbin/mysqld --initialize
        echo "configuration folder ${CONFIG_DIR} does not exist."
        echo "copying default config to ${CONFIG_DIR}"
        cp -r $SNAP/etc/mysql $SNAP_COMMON
        sed -i "s:/var/run/mysqld/mysqld.sock:$SNAP_COMMON/mysqld.sock:g" $SNAP_COMMON/mysql/mysql.conf.d/mysqld.cnf
        sed -i "s: mysql: root:g" $SNAP_COMMON/mysql/mysql.conf.d/mysqld.cnf
        sed -i "s:# sock:sock:g" $SNAP_COMMON/mysql/mysql.conf.d/mysqld.cnf
        sed -i "s:/var/log/mysql/error.log:$SNAP_COMMON/error.log:g" $SNAP_COMMON/mysql/mysql.conf.d/mysqld.cnf
        touch $CONFIG_DIR/initialized
fi

$SNAP/usr/sbin/mysqld --defaults-file=$SNAP_COMMON/mysql/mysql.conf.d/mysqld.cnf --user=root
