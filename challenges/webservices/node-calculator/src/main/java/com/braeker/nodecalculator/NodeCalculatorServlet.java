package com.braeker.nodecalculator;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;

@WebServlet(name = "nodeCalculatorServlet", value = "/nodeCalc")
public class NodeCalculatorServlet extends HttpServlet {

    final String leaderBotLocationFile = "/tmp/location.txt";
    final String leaderBotLocationService = "http://localhost:8080/NodeCalculator/nodeCalc"; // Currently in testing phase


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("Location looks great!");
        // TODO: validate locations
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/xml");

        BufferedReader reader = request.getReader();
        PrintWriter out = response.getWriter();
        Result result = new Result();
        Calculator calculator = new Calculator();

        try {

            // Initialize
            JAXBContext calcContext = JAXBContext.newInstance(Node.class, Calculator.class, Result.class);
            Marshaller marshaller = calcContext.createMarshaller();
            Unmarshaller unmarshaller = calcContext.createUnmarshaller();

            // Unmarshal
            Node node = (Node) unmarshaller.unmarshal(reader);

            // Calculate result
            calculator.setLocationA(node.getLocation());
            calculator.setLocationB(leaderBotLocationFile);
            calculator.setServerValidationCheck(leaderBotLocationService);
            if (!calculator.getServerValidationCheck().equals("200"))
                result.setResult("Leader location doesn't exist");
            else
                result.setResult(calculator.calculateDistance());

            // Output result in XML format
            marshaller.marshal(result, out);

        } catch (Exception e) {
//            throw new RuntimeException(e);
            out.println("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><result><result>-1</result></result>");
        }
    }
}