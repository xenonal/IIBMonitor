/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.listener;

import iibmonitor.tri.event.MQEvent;

/**
 *
 * @author xenon
 */
public interface MQListener {

    public void mqDepthAlertReceived(MQEvent event);

    public void mqExceptionAlertReceived(MQEvent event);

    public void mqPCFAgentExceptionAlertReceived(MQEvent event);
}
