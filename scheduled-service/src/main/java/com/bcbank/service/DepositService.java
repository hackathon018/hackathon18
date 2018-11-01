package com.bcbank.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class DepositService {

    @Value("${contract-closing-deposits-job-enable}")
    private boolean jobEnable;

    @Value("${contract-closing-deposits-function}")
    String functionName;

    @Autowired
    ScheduledService scheduledService;

    public void runJob(boolean jobEnable) {
        this.jobEnable = jobEnable;
    }

    @Scheduled(fixedRateString = "${contract-closing-deposits-period}")
    public void closing() {
        if (jobEnable) {
            scheduledService.execute(functionName);
        }
    }
}
