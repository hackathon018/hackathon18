package com.bcbank.controller;

import com.bcbank.service.CommonService;
import com.bcbank.service.CreditService;
import com.bcbank.service.DepositService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
public class Controller {

    @Autowired
    private CommonService commonService;

    @Autowired
    private DepositService depositService;

    @Autowired
    private CreditService creditService;

    @GetMapping("/check_connect")
    public String checkConnect() throws IOException {
        return commonService.getClientVersion();
    }

    @PostMapping("/start_closing_deposits")
    public void startClosingDeposits() {
        depositService.runJob(true);
    }

    @PostMapping("/stop_closing_deposits")
    public void stopClosingDeposits() {
        depositService.runJob(false);
    }

    @PostMapping("/start_check_credits")
    public void startCheckCredits() {
        creditService.runJob(true);
    }

    @PostMapping("/stop_check_credits")
    public void stopCheckCredits() {
        creditService.runJob(false);
    }
}
