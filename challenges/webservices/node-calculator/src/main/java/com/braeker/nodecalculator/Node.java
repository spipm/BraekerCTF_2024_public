package com.braeker.nodecalculator;

import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.PROPERTY)
@XmlRootElement(name = "Node")
public class Node {
    public void setConstructor(Object Node) {}
    public Object getConstructor() { return null; }

    private String location;
    @XmlElement(name = "location")
    public void setLocation(String location) {
        this.location = location;
    }
    public String getLocation() {
        return this.location;
    }
}

