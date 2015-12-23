# git-java-kafka-example
Kafka producer + consumer example

## You will need

1. Java 8
1. Kafka and zookeeper
    1. `brew update`
    1. `JAVA_HOME=$(/usr/libexec/java_home -v 1.7) brew install kafka` (this should install kafka and zookeeper)

## Running the app

1. Start kafka `bin/kafka.sh restart`
1. Run the app (TBA)

## Testing your kafka setup

1. Start kafka `bin/kafka.sh restart`
1. Send some messages:
    1. `kafka-console-producer.sh --broker-list localhost:2181 --topic test`
    1. Type anything!
1. Consume some messages:
    1. `kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning`