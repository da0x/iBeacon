package com.solstice.glass.notify;

import java.util.Iterator;

import com.solstice.glass.util.Observable;

class OnLocationChangeVisitor extends Observable<OnLocationChangeListener, NotifyArgs> {	
	public static OnLocationChangeVisitor instance = new OnLocationChangeVisitor();
	
	private OnLocationChangeVisitor() {
		
	}
	@Override
	public void visitObservers(NotifyArgs args) {
		if( args != null ) {				
			Iterator<OnLocationChangeListener> iter = iterator();
			while( iter.hasNext() ) {
				OnLocationChangeListener listener = iter.next();
				listener.onLocationChange(args);
			}
		}		
	}	
}
