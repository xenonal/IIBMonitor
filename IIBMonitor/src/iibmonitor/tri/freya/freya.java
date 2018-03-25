/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.freya;


import iibmonitor.tri.listener.MQListener;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.IntegrationServer;
import iibmonitor.tri.data.Queue;
import iibmonitor.tri.data.iibFlow;
import iibmonitor.tri.mqactions.mqActions;
import iibmonitor.tri.mqmonitor.mqMonitor;
import java.io.IOException;
import java.util.Collections;
import java.util.Enumeration;
import org.codehaus.jackson.annotate.JsonAutoDetect.Visibility;
import org.codehaus.jackson.annotate.JsonMethod;
import org.codehaus.jackson.map.ObjectMapper;

import org.codehaus.jackson.map.SerializationConfig;

/**
 *
 * @author xenon
 */
public class freya {

    public void initMonitor(IntegrationNode iibNode) throws IOException {

        System.out.println("Entering Freya logic to setup monitors");


           // Code to loop through the iib object as it is made up other obejects help in array list 
           //we loop through it and set up the listeners for the objects
           //Chi will monitor the broker for changes and add or delete any objects that have been affected.
           //Freya will need to register these new objects with listeners.
        Enumeration<IntegrationServer> intServerlist = Collections.enumeration(iibNode.getIntServerList());
      

        while (intServerlist.hasMoreElements()) {
            IntegrationServer thisIntServer = intServerlist.nextElement();
            Enumeration<iibFlow> flows = Collections.enumeration(thisIntServer.getFlowList());
            while (flows.hasMoreElements()) {
                iibFlow thisFlow = flows.nextElement();
                Enumeration<Queue> queues = Collections.enumeration(thisFlow.getQueues());

                while (queues.hasMoreElements()) {
                    Queue thisQueue = queues.nextElement();
                    MQListener mqActions = new mqActions();
                    thisQueue.getQueueName();
                    //Register a listener for each of the queue objects
                    thisQueue.addMQListener(mqActions);
                    mqMonitor mqMon = new mqMonitor(thisQueue);

                    //this will need to sent to the threading
                    //poentinally send an arraylist to the the queue depth checker
                  //  mqMon.checkDepth(thisQueue);
                    System.out.println(thisQueue.getQueueName());
                     new Thread(mqMon).start();
                     

                }

            }

        }

//     new Thread((Runnable) iibNode).start();
    }

    

}
