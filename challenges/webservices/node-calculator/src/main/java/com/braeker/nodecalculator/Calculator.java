package com.braeker.nodecalculator;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.file.*;
import java.util.stream.IntStream;

public class Calculator {
    private String locationA;
    private String locationB;
    private String serverStatus;

    public void setLocationA(String a) {
        this.locationA = a;
    }
    public String getLocationA() {
        return this.locationA;
    }

    public void setLocationB(String locationFile) throws IOException {
        // Location never exceeds 128 bytes
        byte[] bytes = new byte[128];
        Path path = Paths.get(locationFile);
        InputStream inputStream = Files.newInputStream(path);
        inputStream.read(bytes);
        this.locationB = new String(bytes);
    }
    public String getLocationB() {
        return this.locationB;
    }

    public void setServerValidationCheck(String location) throws IOException {
        URL test = new URL(location + "?leaderLocation=" + URLEncoder.encode(this.locationB) + "&nodeLocationA=" + URLEncoder.encode(this.locationA));
        HttpURLConnection connection = (HttpURLConnection) test.openConnection();
        connection.connect();
        this.serverStatus = String.valueOf(connection.getResponseCode());
    }
    public String getServerValidationCheck() {
        return this.serverStatus;
    }

    public String calculateDistance() {
        return String.valueOf(calculateBinaryDistance(this.locationA, this.locationB));
    }
    public static int calculateBinaryDistance(String str1, String str2) {
        return (int) IntStream.range(0, str1.length()).filter(i -> str1.charAt(i) != str2.charAt(i)).count();
    }
}
