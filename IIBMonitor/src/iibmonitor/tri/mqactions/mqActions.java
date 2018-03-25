/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.mqactions;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import iibmonitor.tri.listener.MQListener;
import iibmonitor.tri.event.MQEvent;
import iibmonitor.tri.iibhelper.IntegrationPolicyHelper;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author xenon
 */
public class mqActions implements MQListener {

    public void mqDepthAlertReceived(MQEvent event) {
        boolean isPolicyDeployd = false;

        IntegrationPolicyHelper polyHelp = new IntegrationPolicyHelper();
        String flowName = event.queue().getFlowName();
        String intServer = event.queue().getExecutionGroup();
        BrokerProxy bp = event.queue().getBp();
        //this will trigger diffrent events 
        //HIGH, LOW WARNING 
        //HIGH - SOMETHING IS DEFINATELY WRONG, TAKE ACTION
        //ALERT THE EXECUTION GROUP EVENT HANDLER AND BROKER HANDLER AND FLOW EVENT HANDLER 

        //THIS WILL TRIGGER CHECKS ON THESE 
        //DEFAULT ACTION IS TO BEM ALERT INCREASE MONITORING OF THE QUEUE AT A HIGHER FREQUENCY
        if (event.queue().getQueueDepth() == 0) {

            System.out.println("Queue: " + event.queue().getQueueName() + "is clear checking for attached policy details");
            try {
                String policy = polyHelp.getAttachPolicy(bp, intServer, flowName);
                System.out.println("Attached Policy on Message Flow " + event.queue().getFlowName() + " is " + policy);
                System.out.println("");

                if (policy != "none" || policy != "LOW") {
                    boolean policyExists = polyHelp.PolicyRetrieve(bp, "LOW");

                    if (policyExists == false) {
                        try {
                            polyHelp.PolicyCreate(bp, "LOW");
                            polyHelp.attachPolicy(bp, "LOW", intServer, flowName);
                        } catch (ConfigManagerProxyPropertyNotInitializedException ex) {
                            Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } else {
                        polyHelp.attachPolicy(bp, "LOW", intServer, flowName);
                    }
                }

            } catch (IOException ex) {
                Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ConfigManagerProxyLoggedException ex) {
                Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
            }

            if (event.queue().getQueueDepth() >= 11) {
                System.out.println("A new queue depth alert has been triggered for the queue: " + event.queue().getQueueName() + "and Depth is: " + event.queue().getQueueDepth());

                System.out.println("Queue: " + event.queue().getQueueName() + "is clear checking for attached policy details");
                try {
                    String policy = polyHelp.getAttachPolicy(bp, intServer, flowName);
                    System.out.println("Attached Policy on Message Flow " + event.queue().getFlowName() + " is " + policy);
                    System.out.println("");

                    if (policy != "none" || policy != "HIGH") {

                        boolean policyExists = polyHelp.PolicyRetrieve(bp, "HIGH");

                        if (policyExists == false) {
                            try {
                                polyHelp.PolicyCreate(bp, "HIGH");
                                polyHelp.attachPolicy(bp, "HIGH", intServer, flowName);
                            } catch (ConfigManagerProxyPropertyNotInitializedException ex) {
                                Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        } else {
                            polyHelp.attachPolicy(bp, "HIGH", intServer, flowName);
                        }

                    }

                } catch (IOException ex) {
                    Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ConfigManagerProxyLoggedException ex) {
                    Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (event.queue().getQueueDepth() <= 10) {
                    System.out.println("A new queue depth alert has been triggered for the queue: " + event.queue().getQueueName() + "and Depth is: " + event.queue().getQueueDepth());

                    System.out.println("Queue: " + event.queue().getQueueName() + "is clear checking for attached policy details");
                    try {
                        String policy = polyHelp.getAttachPolicy(bp, intServer, flowName);
                        System.out.println("Attached Policy on Message Flow " + event.queue().getFlowName() + " is " + policy);
                        System.out.println("");

                        if (policy != "none" || policy != "HIGH") {
                            polyHelp.attachPolicy(bp, "LOW", intServer, flowName);

                        }

                    } catch (IOException ex) {
                        Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (ConfigManagerProxyLoggedException ex) {
                        Logger.getLogger(mqActions.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    if (event.queue().getQueueDepth() >= 10) {
                        System.out.println("A new queue depth alert has been triggered for the queue: " + event.queue().getQueueName() + "and Depth is: " + event.queue().getQueueDepth());

                    }
                }
            }
        }
        if (event.queue().isExists() == false) {
            System.out.println("THE QUEUE DOES NOT EXIST" + event.queue().getQueueName());

            //NEED ANOTHER WAY TO ALERT THAT A FLOW DOESN'T HAVE A QUEUE DEFINED 
        }
        {

        }
    }

    //THESE ARE USUALLY CONECTIVITY ISSUES AND SHOULD SHOULD BE ALERTED ON 
    //QM UNAVAILBLE OR UNABLE TO CONNECT SHOULD TRIGGER THE MQ TEAM TO INVESTIGATE OR 
    // RUN A FORCE RESTART OF THE QM AND BROKER TO TRY AND BRING IT BACK UP. 
    public void mqExceptionAlertReceived(MQEvent event) {

        if (event.queue().getMqe() != null) {

            System.out.println("MQ Exception Has been triggered");
        }

    }

    //THESE ARE USUALLY MISSING QUEUES AND SHOULD BE IMEDIATELY ALERTED ON 
    public void mqPCFAgentExceptionAlertReceived(MQEvent event) {
        if (event.queue().getPcfe() != null) {
            System.out.println("MQ Agent Error detected");
        }

    }
}
