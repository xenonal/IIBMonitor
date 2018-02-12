/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.conectivity.mq;

import com.ibm.mq.MQException;
import com.ibm.mq.MQQueueManager;
import iibmonitor.tri.data.QueueManager;

/**
 *
 * @author xenon
 */
public class Connect_MQ_QueueManger {

    private static MQQueueManager qmcon;

    public static synchronized MQQueueManager getMQ(QueueManager qm) throws MQException {
        if (qmcon != null) {
            return qmcon;
        }
        return getMQCon(qm);
    }

    private static MQQueueManager getMQCon(QueueManager qm) throws MQException {

        qmcon = new MQQueueManager(qm.getName());
        return qmcon;
    }
}
