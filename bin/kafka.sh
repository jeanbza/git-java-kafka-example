#!/usr/bin/env bash
function start_kafka {
    rm -rf /tmp/kafka 2>/dev/null;
    mkdir -p /tmp/kafka/zookeeper-data;
    mkdir -p /tmp/kafka/kafka-logs;
    pushd .;
    cd /tmp/kafka;

    printf "
broker.id=0
port=9092

num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/tmp/kafka/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1

log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=false

zookeeper.connect=0.0.0.0:2181
zookeeper.connection.timeout.ms=6000" >> kafka.properties;

    printf "
dataDir=/tmp/kafka/zookeeper
clientPort=2181" >> zookeeper.properties;

    echo 'Starting zookeeper';
    zkServer start /tmp/kafka/zookeeper.properties;

    echo 'Starting kafka';
    kafka-server-start.sh -daemon /tmp/kafka/kafka.properties;
    echo 'Sleeping 5 to let kafka spin up';
    sleep 5;

    echo 'Creating topic test-topic';
    kafka-topics.sh --create --zookeeper 0.0.0.0:2181 --replication-factor 1 --partitions 1 --topic test-topic;

    popd;
}

function stop_kafka {
    echo 'Stopping kafka';
    kill -9 `ps aux | grep kafka.properties | awk '{print $2}'` 2>/dev/null;
    kill -9 `ps aux | grep zookeeper.properties | awk '{print $2}'` 2>/dev/null;
}

function print_usage {
    echo "Usage: $) <start|stop|restart>"
}

if [ "$1" == 'start' ]; then
    start_kafka
elif [ "$1" == 'stop' ]; then
    stop_kafka
elif [ "$1" == 'restart' ]; then
    stop_kafka
    start_kafka
else
    echo 'Invalid usage';
    print_usage;
fi;