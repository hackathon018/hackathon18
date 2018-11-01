package com.bcbank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.web3j.protocol.Web3j;

@SpringBootApplication
@EnableScheduling
public class BlockchainApp {

    private final Web3j web3j;

    public BlockchainApp(Web3j web3j) {
        this.web3j = web3j;
    }

    public static void main(String[] args) {
        SpringApplication.run(BlockchainApp.class, args);
    }

}
