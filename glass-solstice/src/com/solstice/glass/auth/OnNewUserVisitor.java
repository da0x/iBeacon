package com.solstice.glass.auth;

import java.io.IOException;
import java.util.Iterator;

import com.solstice.glass.util.Observable;

final class OnNewUserVisitor extends Observable<OnNewUserListener, User> {

	public static OnNewUserVisitor instance = new OnNewUserVisitor();
	
	private OnNewUserVisitor() {
		
	}
	
	@Override
	public void visitObservers(User args) throws IOException {
		if( args != null ) {				
			Iterator<OnNewUserListener> iter = iterator();
			while( iter.hasNext() ) {
				OnNewUserListener listener = iter.next();
				listener.onNewUser(args);
			}
		}	
	}
}
