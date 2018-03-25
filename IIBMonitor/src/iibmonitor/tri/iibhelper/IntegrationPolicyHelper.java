/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.iibhelper;

import com.ibm.broker.config.proxy.BrokerProxy;
import com.ibm.broker.config.proxy.ConfigManagerProxyException;
import com.ibm.broker.config.proxy.ConfigManagerProxyLoggedException;
import com.ibm.broker.config.proxy.ConfigManagerProxyPropertyNotInitializedException;
import com.ibm.broker.config.proxy.ExecutionGroupProxy;
import com.ibm.broker.config.proxy.MessageFlowProxy;
import com.ibm.broker.config.proxy.PolicyProxy;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author xenon
 */
public class IntegrationPolicyHelper {
    

    public static String readPolicyFromFile(String fileName) throws IOException {

        byte[] encoded = Files.readAllBytes(Paths.get(fileName));
        return new String(encoded);
    }

    public static String getFilePath(String PolicyName) {
        String filePath = "";
        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");

        if (isWindows) {
            filePath = "E:\\" + PolicyName + ".xml";
        } else {
            filePath = ".//Policy//" + PolicyName + ".xml";
        }
        return filePath;
    }

    public boolean PolicyCreate(BrokerProxy bcp, String policyName) throws IOException, ConfigManagerProxyLoggedException, ConfigManagerProxyPropertyNotInitializedException {

        boolean isCreated = false;
        String filePath = getFilePath(policyName);
        String policyContent = readPolicyFromFile(filePath);

        System.out.println("About to create, policy type" + "WorkloadManagement");
        bcp.createPolicy("WorkloadManagement", policyName, policyContent);
        return isCreated;
    }

    public boolean PolicyRetrieve(BrokerProxy bcp, String policyName) {
        String Policy = "";
        Boolean policyFound = false;

        try {
            PolicyProxy polprox = bcp.getPolicy("WorkloadManagement", policyName);

            if (polprox.getPolicyContent().length() > 1) {
                policyFound = true;
                System.out.println(polprox.getPolicyContent());
            } else {
                policyFound = false;
            }

        } catch (ConfigManagerProxyException ex) {
            ex.printStackTrace();
            policyFound = false;
        }
        return policyFound;
    }

    public boolean UpdatePolicy(BrokerProxy bcp, String policyName) throws IOException, ConfigManagerProxyLoggedException, ConfigManagerProxyPropertyNotInitializedException {

        boolean isUpdated = false;

        String filePath = getFilePath(policyName);
        String policyContent = readPolicyFromFile(filePath);

        System.out.println("About to update, policy type" + "WorkloadManagement");
        bcp.updatePolicy("WorkloadManagement", policyName, policyContent);
        return isUpdated;
    }

    public boolean DeletePolicy(BrokerProxy bcp, String policyType, String policyName, String fileName) throws IOException, ConfigManagerProxyLoggedException, ConfigManagerProxyPropertyNotInitializedException {

        boolean isDeleted = false;

        System.out.println("About to delete, policy type" + policyType);
        bcp.deletePolicy("WorkloadManagement", policyName);
        return isDeleted;
    }

    public boolean attachPolicy(BrokerProxy bcp, String policyName, String executionGroup, String flow) throws IOException, ConfigManagerProxyLoggedException {

        boolean isAttached = false;

        try {
            ExecutionGroupProxy e = bcp.getExecutionGroupByName(executionGroup);
            e.getMessageFlowByName(flow).setRuntimeProperty("This/wlmPolicy", policyName);
            isAttached = true;
        } catch (ConfigManagerProxyPropertyNotInitializedException ex) {
            Logger.getLogger(IntegrationPolicyHelper.class.getName()).log(Level.SEVERE, null, ex);
            isAttached = false;
        }

        return isAttached;
    }
        public String  getAttachPolicy(BrokerProxy bcp,String executionGroup, String flow) throws IOException, ConfigManagerProxyLoggedException {

        String policy;

        try {
            ExecutionGroupProxy e = bcp.getExecutionGroupByName(executionGroup);
            
            MessageFlowProxy mf = e.getMessageFlowByName(flow.replace(".msgflow", ""));
            policy = mf.getRuntimeProperty("This/wlmPolicy");
            
            if (policy == null){
                policy = "none";
            }
            
        } catch (ConfigManagerProxyPropertyNotInitializedException ex) {
            Logger.getLogger(IntegrationPolicyHelper.class.getName()).log(Level.SEVERE, null, ex);
          policy = "";
        }

        return policy;
    }
    
}
