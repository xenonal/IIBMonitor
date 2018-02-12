/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.data;

import com.ibm.broker.config.proxy.BrokerProxy;

import java.util.*;
/**
 *
 * @author xenon
 */
public class IntegrationNode {
    private String nodeName, nodePort, nodeHost, brokerFile;
    private Boolean isRemote;
    private BrokerProxy bp;
    private ArrayList<IntegrationServer> intServerList;
    
    
    public IntegrationNode(){
        
    }
    
    public IntegrationNode(String nodeHost, String nodeName, String nodePort,String brokerFile,BrokerProxy bp, Boolean isRemote, ArrayList<IntegrationServer> intServerList){
        this.nodeHost = nodeHost;
        this.nodeName = nodeName;
        this.nodePort = nodePort;
        this.brokerFile = brokerFile;
        this.bp = bp;
        this.isRemote = isRemote;

        this.intServerList = intServerList;
    }

    /**
     * @return the nodeName
     */
    public String getNodeName() {
        return nodeName;
    }

    /**
     * @param nodeName the nodeName to set
     */
    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }

    /**
     * @return the nodePort
     */
    public String getNodePort() {
        return nodePort;
    }

    /**
     * @param nodePort the nodePort to set
     */
    public void setNodePort(String nodePort) {
        this.nodePort = nodePort;
    }

    /**
     * @return the isRemote
     */
    public Boolean getIsRemote() {
        return isRemote;
    }

    /**
     * @param isRemote the isRemote to set
     */
    public void setIsRemote(Boolean isRemote) {
        this.isRemote = isRemote;
    }

    /**
     * @return the nodeHost
     */
    public String getNodeHost() {
        return nodeHost;
    }

    /**
     * @param nodeHost the nodeHost to set
     */
    public void setNodeHost(String nodeHost) {
        this.nodeHost = nodeHost;
    }

    /**
     * @return the intServerList
     */
    public ArrayList<IntegrationServer> getIntServerList() {
        return intServerList;
    }

    /**
     * @param intServerList the intServerList to set
     */
    public void setIntServerList(ArrayList<IntegrationServer> intServerList) {
        this.intServerList = intServerList;
    }

    /**
     * @return the brokerFile
     */
    public String getBrokerFile() {
        return brokerFile;
    }

    /**
     * @param brokerFile the brokerFile to set
     */
    public void setBrokerFile(String brokerFile) {
        this.brokerFile = brokerFile;
    }

    /**
     * @return the bp
     */
    public BrokerProxy getBp() {
        return bp;
    }

    /**
     * @param bp the bp to set
     */
    public void setBp(BrokerProxy bp) {
        this.bp = bp;
    }
    
}
