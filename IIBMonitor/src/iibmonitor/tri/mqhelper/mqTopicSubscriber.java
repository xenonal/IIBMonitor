/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.mqhelper;

import com.ibm.mq.MQException;
import com.ibm.mq.MQMessage;
import com.ibm.mq.MQQueueManager;
import com.ibm.mq.MQTopic;
import com.ibm.mq.constants.CMQC;
import java.io.IOException;

/**
 *
 * @author xenon
 */
public class mqTopicSubscriber {

    public String GetTopicMesssage(String topicSring, MQQueueManager qmcon) {

        MQMessage mqMsg = null;
        mqMsg = new MQMessage();
        mqMsg.messageId = CMQC.MQMI_NONE;
        mqMsg.correlationId = CMQC.MQCI_NONE;
        boolean more = true;
        String msgText = null;
        while (more) {
            try {
                MQTopic subscriber = qmcon.accessTopic(topicSring, "", CMQC.MQTOPIC_OPEN_AS_SUBSCRIPTION, CMQC.MQSO_MANAGED | CMQC.MQSO_CREATE | CMQC.MQOO_FAIL_IF_QUIESCING);

                subscriber.get(mqMsg);
                msgText = mqMsg.readStringOfByteLength(mqMsg.getMessageLength());
                System.out.println("received message: " + msgText);
                more = false;
            } catch (MQException | IOException e) {
                more = true;

            }
        }
        return msgText;
    }
}
