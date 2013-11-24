/**
 * 
 */
package com.solstice.glass.notify;

import java.io.IOException;
import java.util.Iterator;

import com.solstice.glass.util.Observable;

/**
 * @author henryoyuela
 *
 */
class OnMenuActionVisitor extends Observable<OnMenuActionListener, NotifyArgs> {
	public static OnMenuActionVisitor instance = new OnMenuActionVisitor();
	
	private OnMenuActionVisitor() {
		
	}
	
	@Override
	public void visitObservers(NotifyArgs args) throws IOException {
		if( args != null ) {				
			Iterator<OnMenuActionListener> iter = iterator();
			while( iter.hasNext() ) {
				OnMenuActionListener listener = iterator().next();
				listener.onMenuAction(args);
			}
		}		
	}
}
