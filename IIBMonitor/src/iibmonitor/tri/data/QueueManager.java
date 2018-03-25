/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.data;

import com.ibm.mq.MQQueueManager;
import com.ibm.mq.pcf.PCFMessageAgent;

/**
 *
 * @author xenon
 */
public class QueueManager {

    private String name, port, channel;
    private Boolean isRemote;
    private MQQueueManager qmcon;
    private PCFMessageAgent mqpcfAgent;


    public QueueManager() {

    }

    public QueueManager(String name, String port, String channel, Boolean isRemote, MQQueueManager qmcon, PCFMessageAgent mqpcfAgent) {
        this.name = name;
        this.port = port;
        this.channel = channel;
        this.isRemote = isRemote ;
        this.qmcon = qmcon;
        this.mqpcfAgent = mqpcfAgent;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the port
     */
    public String getPort() {
        return port;
    }

    /**
     * @param port the port to set
     */
    public void setPort(String port) {
        this.port = port;
    }

    /**
     * @return the channel
     */
    public String getChannel() {
        return channel;
    }

    /**
     * @param channel the channel to set
     */
    public void setChannel(String channel) {
        this.channel = channel;
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
     * @return the qmcon
     */
    public MQQueueManager getQmcon() {
        return qmcon;
    }

    /**
     * @param qmcon the qmcon to set
     */
    public void setQmcon(MQQueueManager qmcon) {
        this.qmcon = qmcon;
    }

    /**
     * @return the mqpcfAgent
     */
    public PCFMessageAgent getMqpcfAgent() {
        return mqpcfAgent;
    }

    /**
     * @param mqpcfAgent the mqpcfAgent to set
     */
    public void setMqpcfAgent(PCFMessageAgent mqpcfAgent) {
        this.mqpcfAgent = mqpcfAgent;
    }

}
