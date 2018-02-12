/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.conectivity.mq;

import com.ibm.mq.MQException;
import com.ibm.mq.pcf.PCFMessageAgent;
import iibmonitor.tri.data.QueueManager;

/**
 *
 * @author xenon
 */
public class Connect_MQ_PCFMessageAgent {

private static PCFMessageAgent mqpcfAgent;

public static synchronized PCFMessageAgent getPCFMessageAgent(QueueManager qm) throws MQException{
    
    if (mqpcfAgent !=null){
    return mqpcfAgent;
}
    
    return getPCFMessageAgentCon(qm);
}

private static PCFMessageAgent getPCFMessageAgentCon(QueueManager qm) throws MQException{
 
    mqpcfAgent = new PCFMessageAgent(qm.getQmcon());
    
    return mqpcfAgent;
}
}
