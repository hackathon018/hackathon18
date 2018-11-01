package com.bcbank.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.request.Transaction;
import org.web3j.protocol.http.HttpService;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class ScheduledService {

    private static final Logger log = LoggerFactory.getLogger(DepositService.class);

    @Value("${contract-ownerAccount}")
    String ownerAccount;

    @Value("${contract-address}")
    String contractAddress;

    void execute(String functionName) {
        try {
            Web3j web3j = Web3j.build(new HttpService());
            List<Type> inputParameters = new ArrayList<>();
            List<TypeReference<?>> outputParameters = new ArrayList<>();
            Function function = new Function(functionName,
                    inputParameters, outputParameters);
            String encodedFunction = FunctionEncoder.encode(function);
            web3j.ethCall(Transaction.createEthCallTransaction(ownerAccount,
                    contractAddress, encodedFunction),
                    DefaultBlockParameterName.LATEST).sendAsync().get();
            log.info("Successful function [" + functionName + "] call");
        } catch (ExecutionException | InterruptedException ex) {
            log.error("Function [" + functionName + "] call failed: " + ex.getMessage());
        }
    }

}
