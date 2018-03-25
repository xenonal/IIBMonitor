/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.data;
import com.ibm.mq.pcf.PCFMessageAgent;
import iibmonitor.tri.listener.MQListener;
import iibmonitor.tri.event.MQEvent;
import java.util.*;

/**
 *
 * @author xenon
 */
public class iibFlow {
    
    private String name;
    private String resourceStatsTopic;
    private String isRunning;
    private String version; // monitor will need to be set up on this to look at the current and if the version is diffrent for the broker to apply heavier monitoring
    private ArrayList<Queue> queues;
    private String deployedPolicy;
   
  
    
    public iibFlow(){
        
    }
    public iibFlow(String name, String resourceStatsTopic, String isRunning, String version, ArrayList<Queue> queues, String deployedPolicy){
        this.name = name;
        this.resourceStatsTopic = resourceStatsTopic;
        this.isRunning = isRunning;
        this.version = version;
        this.queues = queues;
        this.deployedPolicy = deployedPolicy;
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
     * @return the queues
     */
    public ArrayList<Queue> getQueues() {
        return queues;
    }

    /**
     * @param queues the queues to set
     */
    public void setQueues(ArrayList<Queue> queues) {
        this.queues = queues;
    }

    /**
     * @return the isRunning
     */
    public String getIsRunning() {
        return isRunning;
    }

    /**
     * @param isRunning the isRunning to set
     */
    public void setIsRunning(String isRunning) {
        this.isRunning = isRunning;
    }

    /**
     * @return the version
     */
    public String getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(String version) {
        this.version = version;
    }

    /**
     * @return the resourceStatsTopic
     */
    public String getResourceStatsTopic() {
        return resourceStatsTopic;
    }

    /**
     * @param resourceStatsTopic the resourceStatsTopic to set
     */
    public void setResourceStatsTopic(String resourceStatsTopic) {
        this.resourceStatsTopic = resourceStatsTopic;
    }

    /**
     * @return the deployedPolicy
     */
    public String getDeployedPolicy() {
        return deployedPolicy;
    }

    /**
     * @param deployedPolicy the deployedPolicy to set
     */
    public void setDeployedPolicy(String deployedPolicy) {
        this.deployedPolicy = deployedPolicy;
    }

    
       
}
