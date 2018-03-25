/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor;

import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.mq.MQException;
import iibmonitor.tri.chi.Chi;
import java.io.IOException;

/**
 *
 * @author xenon
 */
public class IIBMonitor {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws MQException, ConfigManagerProxyPropertyNotInitializedException, IOException, ConfigManagerProxyLoggedException {

        //Delegate to CHI, who will start the intalisations, either xargs will be passed to chi or she will assume a prop file 
        // is included in the same directory. 
        Chi chi = new Chi();
        chi.initIIBObjects();
        
        //Once Chi has finised her job Freya will take care of the monitoring and protecttion
        //Chi will then perform a monitor of the broker for changes if it has she will trigger a reinisalisation of all objects and listeners
        

    }

}
