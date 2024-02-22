package com.braeker.nodecalculator;

import jakarta.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Result {
    private String resultRaw;

    public void setResult(String result) {
        this.resultRaw = result;
    }
    public String getResult() {
        return this.resultRaw;
    }
}
