/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.connectivity.iib;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.IntegrationNodeConnectionParameters;
import iibmonitor.tri.data.IntegrationNode;

/**
 *
 * @author xenon
 */
public class Connect_IIB {

    private static BrokerProxy bp;

    public static synchronized BrokerProxy getBrokerProxy(IntegrationNode intNode) {
        if (bp != null) {
            return bp;
        }
        return getBrokerProxyCon(intNode);

    }

    private static BrokerProxy getBrokerProxyCon(IntegrationNode intNode) {

        try {
            if (intNode.getIsRemote() == true) {
                System.out.println("Connectioning to the broker via broker file: " + intNode.getBrokerFile());
                bp = BrokerProxy.getInstance(new IntegrationNodeConnectionParameters(intNode.getBrokerFile()));
                return bp;
            }
            if (intNode.getIsRemote() == false) {
                bp = BrokerProxy.getLocalInstance(intNode.getNodeName());
                return bp;
            }
            
            //MAY NEED TO LOOK UP A LOCAL FILE BUT REALLY DOON'T TO DO THIS FOR REMOTE.

        } catch (ConfigManagerProxyLoggedException ex) {
            ex.printStackTrace();
        }
        return null;
    }
}
