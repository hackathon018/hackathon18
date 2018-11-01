package com.bcbank.service;

import org.springframework.stereotype.Service;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;

import java.io.IOException;

@Service
public class CommonService {

    public String getClientVersion() throws IOException {
        Web3j web3 = Web3j.build(new HttpService());
        Web3ClientVersion web3ClientVersion = web3.web3ClientVersion().send();
        return web3ClientVersion.getWeb3ClientVersion();
    }
}
