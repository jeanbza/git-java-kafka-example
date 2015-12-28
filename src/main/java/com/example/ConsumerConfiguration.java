package com.example;

import org.springframework.context.annotation.Bean;
import org.springframework.integration.dsl.*;
import org.springframework.integration.dsl.kafka.*;
import org.springframework.integration.dsl.support.Consumer;
import org.springframework.integration.kafka.support.ZookeeperConnect;

import java.util.*;

public class ConsumerConfiguration {
	@Bean IntegrationFlow consumer() {
      KafkaHighLevelConsumerMessageSourceSpec messageSourceSpec = Kafka.inboundChannelAdapter(
          new ZookeeperConnect("0.0.0.0:2181"))
            .consumerProperties(props ->
                props.put("auto.offset.reset", "smallest")
                     .put("auto.commit.interval.ms", "100"))
            .addConsumer("myGroup", metadata -> metadata.consumerTimeout(100)
              .topicStreamMap(m -> m.put("test-topic", 1))
              .maxMessages(10)
              .valueDecoder(String::new));

      Consumer<SourcePollingChannelAdapterSpec> endpointConfigurer = e -> e.poller(p -> p.fixedDelay(100));

      return IntegrationFlows
        .from(messageSourceSpec, endpointConfigurer)
        .<Map<String, List<String>>>handle((payload, headers) -> {
            payload.entrySet().forEach(e -> System.out.println(e.getKey() + '=' + e.getValue()));
            return null;
        })
        .get();
    }
}
