/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.data;
import com.ibm.broker.config.proxy.BrokerProxy;
import java.util.*;
/**
 *
 * @author xenon
 */
public class IntegrationServer {
    private String name;
    private ArrayList<iibFlow> flowList;
    private BrokerProxy bp;
    
    public IntegrationServer(){
        
    }
    public IntegrationServer(String name, ArrayList<iibFlow> flowList,BrokerProxy bp){
        this.name = name;
        this.flowList = flowList;
        this.bp = bp;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the flowList
     */
    public ArrayList<iibFlow> getFlowList() {
        return flowList;
    }

    /**
     * @param flowList the flowList to set
     */
    public void setFlowList(ArrayList<iibFlow> flowList) {
        this.flowList = flowList;
    }

    /**
     * @return the bp
     */
    public BrokerProxy getBp() {
        return bp;
    }

    /**
     * @param bp the bp to set
     */
    public void setBp(BrokerProxy bp) {
        this.bp = bp;
    }
}
