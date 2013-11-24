package com.solstice.glass.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Nonnull;

public abstract class Observable<T, A>{
	/**
	 * List of listeners notified when a change event occurs on BankUser
	 */
	@Nonnull
	private final List<T> listeners;

	public Observable() {
		listeners = new ArrayList<T>();
	}
	
	public void add(T observer){
		boolean found = false;

		if (observer != null) {
			for (final T item : listeners) {
				if (item == observer) {
					found = true;
					break;
				}
			}

			if (!found) {
				listeners.add(observer);
			}
		}
	}
	
	public void remove(T observer) {
		if (observer != null) {
			listeners.remove(observer);
		}
	}
	
	public Iterator<T> iterator() {
		return listeners.iterator();
	}
	
	public T getAtIndex(int i){
		return listeners.get(i);
	}	
	
	public abstract void visitObservers(A args) throws IOException;
	
	
}
