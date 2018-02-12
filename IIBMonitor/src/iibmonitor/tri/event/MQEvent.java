/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iibmonitor.tri.event;

import iibmonitor.tri.data.Queue;
import java.util.EventObject;

/**
 *
 * @author xenon
 */
public class MQEvent extends EventObject {
    
    private Queue _queue;
    
    public MQEvent( Object source, Queue queue ) {
        super( source );
        _queue = queue;
    }

    public  Queue queue() {
        return _queue;
    }
    
    
}
