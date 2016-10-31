#!/bin/sh

cd /tmp

if [ $# -ne 1 ]; then
	echo "*.sh create/run"
	exit 1
fi

start() {
	cd 0
	redis-server redis.conf &
	cd ../1
	redis-server redis.conf &
	cd ../2
	redis-server redis.conf &
	cd ../3
	redis-server redis.conf &
	cd ../4
	redis-server redis.conf &
	cd ../5
	redis-server redis.conf &
}

if [ $1 = "config" ]; then
	mkdir 0 1 2 3 4 5
	cat << eof > 0/redis.conf
port 7000
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	cat << eof > 1/redis.conf
port 7001
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	cat << eof > 2/redis.conf
port 7002
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	cat << eof > 3/redis.conf
port 7003
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	cat << eof > 4/redis.conf
port 7004
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	cat << eof > 5/redis.conf
port 7005
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
eof
	start
elif [ $1 = "start" ]; then
	start
elif [ $1 = "kill" ]; then
	killall redis-server > /dev/null
fi

cd ..
echo 'started'

