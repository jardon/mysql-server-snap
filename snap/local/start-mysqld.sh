#!/bin/bash

export CONFIG_DIR="${SNAP_COMMON}/mysql"
if [ ! -f "${CONFIG_DIR}/initialized" ]; then
        $SNAP/usr/sbin/mysqld --initialize
        echo "configuration folder ${CONFIG_DIR} does not exist."
        echo "copying default config to ${CONFIG_DIR}"
        cp -r $SNAP/etc/mysql $SNAP_COMMON
        touch $CONFIG_DIR/initialized
        grep -r sock /etc/mysql > $SNAP_COMMON/sock.txt
fi

$SNAP/usr/sbin/mysqld --user=root