/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.iibhelper;

import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.broker.config.proxy.ExecutionGroupProxy;
import com.ibm.mq.MQException;
import iibmonitor.tri.data.IntegrationNode;
import iibmonitor.tri.data.IntegrationServer;
import iibmonitor.tri.data.QueueManager;
import iibmonitor.tri.data.iibFlow;
import java.util.ArrayList;
import java.util.Enumeration;

/**
 *
 * @author xenon
 */
public class integrationServerHelper {

    IntegrationNode iibNode;
    QueueManager qm;

    public ArrayList<IntegrationServer> getIntServers(IntegrationNode iibNode, QueueManager qm) throws ConfigManagerProxyPropertyNotInitializedException, MQException {
        Enumeration<ExecutionGroupProxy> allEGs = iibNode.getBp().getExecutionGroups(null);
        ArrayList<IntegrationServer> intServerList = new ArrayList<IntegrationServer>();
        ArrayList<iibFlow> intFlowList = new ArrayList<iibFlow>();
        IntegrationFlowHelper iibflowHelp = new IntegrationFlowHelper();

        while (allEGs.hasMoreElements()) {
            ExecutionGroupProxy thisEG = allEGs.nextElement();

            IntegrationServer intServ = new IntegrationServer(thisEG.getName(), null, iibNode.getBp());
            intFlowList = iibflowHelp.getIntServers(intServ,qm);
            intServ.setFlowList(intFlowList);
            intServerList.add(intServ);

            System.out.println("New flow has been added to the Integration Server list" + thisEG.getName());
        }
        return intServerList;

    }

}
