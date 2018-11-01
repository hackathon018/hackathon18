package com.bcbank.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class CreditService {

    @Value("${contract-check-credits-job-enable}")
    private boolean jobEnable;

    @Value("${contract-check-credits-function}")
    String functionName;

    @Autowired
    ScheduledService scheduledService;

    public void runJob(boolean jobEnable) {
        this.jobEnable = jobEnable;
    }

    @Scheduled(fixedRateString = "${contract-check-credits-period}")
    public void check() {
        if (jobEnable) {
            scheduledService.execute(functionName);
        }
    }
}
