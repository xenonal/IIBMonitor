/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.data;

import com.ibm.mq.MQException;
import com.ibm.mq.pcf.PCFException;
import com.ibm.mq.pcf.PCFMessageAgent;
import iibmonitor.trI.listener.MQListener;
import iibmonitor.tri.event.MQEvent;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 *
 * @author xenon
 */
public class Queue {

    private String queueName;
    private boolean exists = false;
    private int queueDepth = 0;
    private int poleTime = 10; // This will need to be defualted to 30 seconds or overridden via args 
    private String status = "Normal";
    private List _listeners = new ArrayList();
    private Queue _queue = Queue.this;
    private PCFMessageAgent mqpcfAgent;
    private MQException mqe;
    private PCFException pcfe;

    public Queue() {

    }

    public Queue(String queueName, boolean exists, int queueDepth, int poleTime, String status, PCFMessageAgent mqpcfAgent, MQException mqe,PCFException pcfe) {
        queueName = this.queueName;
        exists = this.exists;
        queueDepth = this.queueDepth;
        poleTime = this.poleTime;
        status = this.status;
        mqpcfAgent = this.mqpcfAgent;
        mqe = this.mqe;
        pcfe = this.pcfe;
    }

    /**
     * @return the queueName
     */
    public String getQueueName() {
        return queueName;
    }

    /**
     * @param queueName the queueName to set
     */
    public void setQueueName(String queueName) {
        this.queueName = queueName;
    }

    /**
     * @return the queueDepth
     */
    public int getQueueDepth() {
        return queueDepth;
    }

    /**
     * @param queueDepth the queueDepth to set
     */
    public void setQueueDepth(int queueDepth) {
        this.queueDepth = queueDepth;
    }

    /**
     * @return the poleTime
     */
    public int getPoleTime() {
        return poleTime;
    }

    /**
     * @param poleTime the poleTime to set
     */
    public void setPoleTime(int poleTime) {
        this.poleTime = poleTime;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    public synchronized void addMQListener(MQListener l) {
        getListeners().add(l);
    }

    public synchronized void removeMQListener(MQListener l) {
        getListeners().remove(l);
    }

    
    //implement other MQ events to keep the code simple 
    private synchronized void _fireMQDepthEvent() {
        MQEvent mqevent = new MQEvent(this, getQueue());
        Iterator listeners = getListeners().iterator();
        while (listeners.hasNext()) {
            ((MQListener) listeners.next()).mqDepthAlertReceived(mqevent);
        }
    }
    
     private synchronized void _fireMQExceptionEvent() {
        MQEvent mqevent = new MQEvent(this, getQueue());
        Iterator listeners = getListeners().iterator();
        while (listeners.hasNext()) {
            ((MQListener) listeners.next()).mqExceptionAlertReceived(mqevent);
        }
    }
     
          private synchronized void _fireMQPCFEAgentExceptionEvent() {
        MQEvent mqevent = new MQEvent(this, getQueue());
        Iterator listeners = getListeners().iterator();
        while (listeners.hasNext()) {
            ((MQListener) listeners.next()).mqPCFAgentExceptionAlertReceived(mqevent);
        }
    }

    /**
     * @return the _listeners
     */
    public List getListeners() {
        return _listeners;
    }

    /**
     * @param _listeners the _listeners to set
     */
    public void setListeners(List _listeners) {
        this._listeners = _listeners;
    }

    /**
     * @return the _queue
     */
    public Queue getQueue() {
        return _queue;
    }

    /**
     * @param _queue the _queue to set
     */
    public void setQueue(Queue _queue) {
        this._queue = _queue;
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

    public synchronized void receiveQueueDepthAlert() {
        if (Queue.this.getStatus().equalsIgnoreCase("warning") || (Queue.this.getStatus().equalsIgnoreCase("error") )) {
            _fireMQDepthEvent();
        }
    }
    
    public synchronized void recieveMQExcpetionAlert(){
        if (Queue.this.getMqe() != null){
            _fireMQExceptionEvent();
        }
    }
    
     public synchronized void recieveMQPCFEAgentExcpetionAlert(){
        if (Queue.this.getMqpcfAgent() != null){
            _fireMQPCFEAgentExceptionEvent();
        }
    }
    
    
    
    //// need to create alerts for MQ errors 
    
    //MQ connection errors
    //pcfe errors when selecting mq objects.

    /**
     * @return the exists
     */
    public boolean isExists() {
        return exists;
    }

    /**
     * @param exists the exists to set
     */
    public void setExists(boolean exists) {
        this.exists = exists;
    }

    /**
     * @return the mqe
     */
    public MQException getMqe() {
        return mqe;
    }

    /**
     * @param mqe the mqe to set
     */
    public void setMqe(MQException mqe) {
        this.mqe = mqe;
    }

    /**
     * @return the pcfe
     */
    public PCFException getPcfe() {
        return pcfe;
    }

    /**
     * @param pcfe the pcfe to set
     */
    public void setPcfe(PCFException pcfe) {
        this.pcfe = pcfe;
    }

}
