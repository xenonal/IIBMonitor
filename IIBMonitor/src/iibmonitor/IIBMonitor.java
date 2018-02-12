/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.mq.MQException;
import com.ibm.mq.MQQueueManager;
import iibmonitor.tri.chi.Chi;
import iibmonitor.tri.conectivity.mq.Connect_MQ_QueueManger;
import iibmonitor.tri.connectivity.iib.Connect_IIB;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.IntegrationServer;
import iibmonitor.tri.data.QueueManager;
import iibmonitor.tri.data.iibFlow;
import iibmonitor.tri.iibhelper.integrationServerHelper;
import iibmonitor.tri.mqmonitor.mqMonitor;
import java.util.ArrayList;

/**
 *
 * @author xenon
 */
public class IIBMonitor {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws MQException, ConfigManagerProxyPropertyNotInitializedException {

        //Delegate to CHI, who will start the intalisations, either xargs will be passed to chi or she will assume a prop file 
        // is included in the same directory. 
        Chi chi = new Chi();
        chi.initIIBObjects();
        
        //Once Chi has finised her job Freya will take care of the monitoring and protecttion
        //Chi will then perform a monitor of the broker for changes if it has she will trigger a reinisalisation of all objects and listeners
        

    }

}
