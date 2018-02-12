/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.iibhelper;

import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.broker.config.proxy.MessageFlowProxy;
import com.ibm.mq.MQException;
import iibmonitor.trI.listener.MQListener;
import iibmonitor.tri.data.IntegrationServer;
import iibmonitor.tri.data.Queue;
import iibmonitor.tri.data.QueueManager;
import iibmonitor.tri.data.iibFlow;
import iibmonitor.tri.mqactions.mqActions;
import iibmonitor.tri.mqmonitor.mqMonitor;
import java.util.ArrayList;
import java.util.Enumeration;

/**
 *
 * @author xenon
 */
public class IntegrationFlowHelper {

    iibFlow iibFlow;

    public ArrayList<iibFlow> getIntServers(IntegrationServer intServer, QueueManager qm) throws ConfigManagerProxyPropertyNotInitializedException, MQException {
        Enumeration<MessageFlowProxy> allflows = intServer.getBp().getExecutionGroupByName(intServer.getName()).getMessageFlows(null);
        ArrayList<iibFlow> iibFlowList = new ArrayList<>();
        ArrayList<Queue> queuesList = new ArrayList<>();


        while (allflows.hasMoreElements()) {
            MQListener mqActions = new mqActions();
            MessageFlowProxy thisFlow = allflows.nextElement();
            iibFlow iibFlow = new iibFlow(thisFlow.getFullName(), null);
            String[] queues = thisFlow.getQueues();

            for (int i = 0; i < queues.length; i++) {
                String queueName = queues[i];
                Queue qu = new Queue(queueName,false,0, 0, null, null,null,null);
                
                //might need to do a test to see if a prefix is on the loacl queue
                //if not assume whats on the queue is whats there
                qu.setQueueName(queueName);
                qu.setMqpcfAgent(qm.getMqpcfAgent());
                queuesList.add(qu);
                qu.addMoodListener(mqActions);
                mqMonitor mqMon = new mqMonitor();
                mqMon.checkDepth(qu);

            }
            //List<String> queueList = new ArrayList<String>(Arrays.asList(queues));
            iibFlow.setQueues((ArrayList<Queue>) queuesList);
            iibFlowList.add(iibFlow);
            System.out.println("New flow has been added to the Integration Flow list " + thisFlow.getFullName());//+ intServ.getName());

        }
        return iibFlowList;
    }
}
