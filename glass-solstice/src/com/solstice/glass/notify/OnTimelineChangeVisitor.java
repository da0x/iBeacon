package com.solstice.glass.notify;

import java.util.Iterator;

import com.solstice.glass.util.Observable;

class OnTimelineChangeVisitor extends Observable<OnTimelineChangeListener, NotifyArgs> {
	public static OnTimelineChangeVisitor instance = new OnTimelineChangeVisitor();
	
	private OnTimelineChangeVisitor() {
		
	}
	
	@Override
	public void visitObservers(NotifyArgs args) {
		if( args != null ) {				
		    Iterator<OnTimelineChangeListener> iter = iterator();
			while( iter.hasNext() ) {
				OnTimelineChangeListener listener = iter.next();
				listener.onTimelineChange(args);
			}
		}		
	}
}
