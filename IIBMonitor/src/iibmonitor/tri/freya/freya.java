/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.freya;

import iibmonitor.trI.listener.MQListener;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.IntegrationServer;
import iibmonitor.tri.data.Queue;
import iibmonitor.tri.data.iibFlow;
import iibmonitor.tri.mqactions.mqActions;
import iibmonitor.tri.mqmonitor.mqMonitor;
import java.util.Collections;
import java.util.Enumeration;

/**
 *
 * @author xenon
 */
public class freya implements Runnable {

    public void initMonitor(IntegrationNode iibNode) {

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
                    mqMonitor mqMon = new mqMonitor();

                    //this will need to sent to the threading
                    //poentinally send an arraylist to the the queue depth checker
                    mqMon.checkDepth(thisQueue);
                    System.out.println(thisQueue.getQueueName());

                }

            }

        }

//     new Thread((Runnable) iibNode).start();
    }

    public void run() {

        //will be used to run the threads 
    }

}
