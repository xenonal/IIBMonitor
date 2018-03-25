/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.chi;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.mq.MQException;
import com.ibm.mq.MQTopic;
import iibmonitor.tri.conectivity.mq.Connect_MQ_PCFMessageAgent;
import iibmonitor.tri.conectivity.mq.Connect_MQ_QueueManger;
import iibmonitor.tri.connectivity.iib.Connect_IIB;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.QueueManager;
import iibmonitor.tri.freya.freya;
import iibmonitor.tri.iibhelper.integrationServerHelper;


import javax.jms.JMSException;
import javax.jms.Session;

import com.ibm.jms.JMSMessage;
import com.ibm.jms.JMSTextMessage;

import com.ibm.mq.jms.MQTopicConnection;
import com.ibm.mq.jms.MQTopicConnectionFactory;
import com.ibm.mq.jms.MQTopicPublisher;
import com.ibm.mq.jms.MQTopicSession;
import com.ibm.mq.jms.MQTopicSubscriber;
import com.ibm.jms.*;
import com.ibm.mq.MQMessage;
import com.ibm.mq.constants.CMQC;
import com.ibm.mq.jms.*;
import com.ibm.msg.client.wmq.WMQConstants;
import java.io.IOException;

/**
 *
 * @author xenon
 */
public class Chi {

    public void initIIBObjects() throws MQException, ConfigManagerProxyPropertyNotInitializedException, IOException, ConfigManagerProxyLoggedException {

        String nodeName, nodePort, brokerFile;
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
        
        
        // Crazy subscription logic 
//        MQTopic subscriber =  qm.getQmcon().accessTopic("$SYS/Broker/IIB10BRK/StatisticsAccounting/Archive/jamea/#", "", CMQC.MQTOPIC_OPEN_AS_SUBSCRIPTION, CMQC.MQSO_MANAGED | CMQC.MQSO_CREATE | CMQC.MQOO_FAIL_IF_QUIESCING);
//               
//                MQMessage mqMsg = null;
//               mqMsg = new MQMessage();
//               mqMsg.messageId = CMQC.MQMI_NONE;
//               mqMsg.correlationId = CMQC.MQCI_NONE;
//              boolean more = true;
//               while (more)
//         {
//             try{
//           
//          //   subscriber.get(mqMsg);
//              String msgText = null;
//             msgText = mqMsg.readStringOfByteLength(mqMsg.getMessageLength());
//             System.out.println("received message: " + msgText);
//             more = false;
//             }
//                         catch (MQException e)
//            {
//               more = true;
//              
//            }
//            catch (IOException e)
//            {
//               more = true;
//              
//            }
//         }
               //end of crazy mq sub logic
            
        //connect to the PCFAgent and set it in the MQ object
        qm.setMqpcfAgent(Connect_MQ_PCFMessageAgent.getPCFMessageAgent(qm));
        //populate the integration servers details.
        intNode.setIntServerList(intHelp.getIntServers(intNode, qm));
        
        String test = "just here to look good";
         freya freya = new freya();
         freya.initMonitor(intNode);
        
        //Once the objects have been created freya will then create threads for each of the monotitors
        
    }

}
