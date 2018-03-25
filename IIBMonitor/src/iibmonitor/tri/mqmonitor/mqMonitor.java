/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.mqmonitor;

import com.ibm.mq.MQException;
import com.ibm.mq.pcf.CMQC;
import com.ibm.mq.pcf.CMQCFC;
import com.ibm.mq.pcf.PCFException;
import com.ibm.mq.pcf.PCFMessage;
import com.ibm.mq.pcf.PCFMessageAgent;
import iibmonitor.tri.data.Queue;
import java.io.IOException;
import java.util.logging.Level;
import org.apache.log4j.Logger;

/**
 *
 * @author xenon
 */
public class mqMonitor implements Runnable {
 protected static Logger logger = Logger.getLogger(mqMonitor.class);
 protected static boolean isDebugEnabled = logger.isDebugEnabled();
 public Queue queue;
 
 public mqMonitor(Queue queue){
     
      this.queue = queue;
      System.out.println("");
 }
 
public void run() {
  
    boolean run =true;
  while (run == true) {
   run = checkDepth(queue);
   
   
      try {
          Thread.sleep(10); // sleep for 30 seconds
      } catch (InterruptedException ex) {
          java.util.logging.Logger.getLogger(mqMonitor.class.getName()).log(Level.SEVERE, null, ex);
      }
   }
}
    
  public boolean checkDepth(Queue queue) {
  PCFMessageAgent agent = null;
  
  String queueName = queue.getQueueName();
  System.out.println(queueName);
  int alertDepth =0;
    
  int[] attrs = { CMQC.MQCA_Q_NAME, CMQC.MQIA_CURRENT_Q_DEPTH };
  PCFMessage request = new PCFMessage(CMQCFC.MQCMD_INQUIRE_Q);
  request.addParameter(CMQC.MQCA_Q_NAME, queueName);
  request.addParameter(CMQC.MQIA_Q_TYPE, CMQC.MQQT_LOCAL);
  request.addParameter(CMQCFC.MQIACF_Q_ATTRS, attrs);
  PCFMessage[] responses;

  if (isDebugEnabled) {
   logger.debug("Connecting to " + queue.getMqpcfAgent().getQManagerName());
  }
  try {
   // Connect a PCFAgent to the queue manager
   agent = new PCFMessageAgent(queue.getMqpcfAgent().getQManagerName());
   // Use the agent to send the request
   responses = agent.send(request);
   // retrieving queue depth
   for (int i = 0; i < responses.length; i++) {
    String name = responses[i].getStringParameterValue(CMQC.MQCA_Q_NAME);
    int depth = responses[i].getIntParameterValue(CMQC.MQIA_CURRENT_Q_DEPTH);
    queue.setExists(true);
    if (isDebugEnabled && name != null)
     logger.debug("Queue " + name + " Depth " + depth);
    if (name != null && queueName.equals(name.trim())) { // just for safety
     if (depth >= alertDepth) {
      logger.info(queue.getMqpcfAgent().getQManagerName() + "/" + queueName + " depth = " + depth
        + ", exceeded alert threshold: " + alertDepth);
      System.out.println("ive found it");
      queue.setQueueDepth(depth);
      queue.setStatus("WARNING");
      queue.receiveQueueDepthAlert();
     }
    }
   }
  }
  catch (PCFException pcfe) {
       queue.setStatus("ERROR");
       queue.setPcfe(pcfe);
       queue.recieveMQPCFEAgentExcpetionAlert();
   logger.error("PCFException caught", pcfe);
   PCFMessage[] msgs = (PCFMessage[]) pcfe.exceptionSource;
   for (int i = 0; i < msgs.length; i++) {
    logger.error(msgs[i]);
     return false;
    
//This exceptio handler need to be extended as if a queue does not exist this should be considered a serious issue.    
   }
      
  }
  catch (MQException mqe) {
      queue.setStatus("ERROR");
      queue.setMqe(mqe);
      queue.recieveMQExcpetionAlert();
   logger.error("MQException caught", mqe);
     return false;
  }

  catch (IOException ioe) {
   logger.error("IOException caught", ioe);
  }
  finally {
   // Disconnect
   if (agent != null) {
    try {
     agent.disconnect();
    }
    catch (Exception e) {
     logger.error("Exception caught during disconnect", e);
    }
   }
   else {
    logger.warn("unable to disconnect, agent is null.");
   }
  }
  return true;
 }
    
}
