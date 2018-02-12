/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.mqactions;

import iibmonitor.trI.listener.MQListener;
import iibmonitor.tri.event.MQEvent;

/**
 *
 * @author xenon
 */
public class mqActions implements MQListener {

    public void mqDepthAlertReceived(MQEvent event) {
        
        //this will trigger diffrent events 
        //HIGH, LOW WARNING 
        //HIGH - SOMETHING IS DEFINATELY WRONG, TAKE ACTION
        //ALERT THE EXECUTION GROUP EVENT HANDLER AND BROKER HANDLER AND FLOW EVENT HANDLER 
        
        //THIS WILL TRIGGER CHECKS ON THESE 
        
        //DEFAULT ACTION IS TO BEM ALERT INCREASE MONITORING OF THE QUEUE AT A HIGHER FREQUENCY
        
        if( event.queue().getQueueDepth() == 0 )
        {
            System.out.println( "A new queue depth alert has been triggered for the queue: "+ event.queue().getQueueName() + "and Depth is: "+ event.queue());
        }
        if( event.queue().isExists()== false ){
            System.out.println("THE QUEUE DOES NOT EXIST");
        }
        {
            
        }
    }

    
    
    //THESE ARE USUALLY CONECTIVITY ISSUES AND SHOULD SHOULD BE ALERTED ON 
    //QM UNAVAIBLE OR UNABLE TO CONNECT SHOULD TRIGGER THE MQ TEAM TO INVESTIGATE OR 
    // RUN A FORCE RESTART OF THE QM AND BROKER TO TRY AND BRING IT BACK UP. 
    public void mqExceptionAlertReceived(MQEvent event) {
        
        if (event.queue().getMqe() != null){
            
            System.out.println("MQ Exception Has been triggered");
        }
        
    }

    
    //THESE ARE USUALLY MISSING QUEUES AND SHOULD BE IMEDIATELY ALERTED ON 
    
    public void mqPCFAgentExceptionAlertReceived(MQEvent event) {
        if (event.queue().getPcfe() != null){
            System.out.println("MQ Agent Error detected");
        }
       
    }
}
