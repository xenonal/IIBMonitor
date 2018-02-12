/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.chi;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.mq.MQException;
import com.ibm.mq.MQQueueManager;
import com.ibm.mq.pcf.PCFMessageAgent;
import iibmonitor.tri.conectivity.mq.Connect_MQ_PCFMessageAgent;
import iibmonitor.tri.conectivity.mq.Connect_MQ_QueueManger;
import iibmonitor.tri.connectivity.iib.Connect_IIB;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.QueueManager;
import iibmonitor.tri.iibhelper.integrationServerHelper;

/**
 *
 * @author xenon
 */
public class Chi {

    public void initIIBObjects() throws MQException, ConfigManagerProxyPropertyNotInitializedException {

        String nodeName, nodePort, nodeHost, brokerFile;
        Boolean isRemote;
        BrokerProxy bp;


        //Create the base intNode object used to pupopulate the rest of the broker.
        //properties file should be used to create a broker file. unless there is a command to create a .broker file
        IntegrationNode intNode = new IntegrationNode(null, "IIB10BRK", null, "E://test.broker", null, true, null);
        integrationServerHelper intHelp = new integrationServerHelper();

        //Create a connection to the broker and set it in the broker proxy  
        bp = Connect_IIB.getBrokerProxy(intNode);
        intNode.setBp(bp);
        
         //Create the QM object minus the connections to the QM and PCFAGENT as we need a base object first
        QueueManager qm = new QueueManager(bp.getQueueManagerName(), null, null, false, null, null);
        //connect to the queueManager and add it to the QM object 
        qm.setQmcon(Connect_MQ_QueueManger.getMQ(qm));

        //connect to the PCFAgent and set it in the MQ object
        qm.setMqpcfAgent(Connect_MQ_PCFMessageAgent.getPCFMessageAgent(qm));
        //populate the integration servers details.
        intNode.setIntServerList(intHelp.getIntServers(intNode, qm));
        
        //Once the objects have been created freya will then create threads for each of the monotitors
        
    }

}
