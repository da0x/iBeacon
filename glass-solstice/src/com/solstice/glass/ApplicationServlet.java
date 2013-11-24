/*
 * Copyright (C) 2013 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.solstice.glass;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.api.services.mirror.Mirror;
import com.google.api.services.mirror.model.Notification;
import com.solstice.glass.auth.AuthManager;
import com.solstice.glass.auth.OnNewUserListener;
import com.solstice.glass.notify.NotificationManager;
import com.solstice.glass.notify.NotifyArgs;
import com.solstice.glass.notify.OnLocationChangeListener;
import com.solstice.glass.notify.OnMenuActionListener;
import com.solstice.glass.notify.OnTimelineChangeListener;
import com.solstice.glass.util.MirrorClient;

/**
 * Handles the notifications sent back from subscriptions
 * 
 * @author Jenny Murphy - http://google.com/+JennyMurphy
 */
public abstract class ApplicationServlet extends HttpServlet 
	implements OnMenuActionListener, OnLocationChangeListener, OnTimelineChangeListener, OnNewUserListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = 9097537286782557716L;
	private static final Logger LOG = Logger.getLogger(ApplicationServlet.class.getSimpleName());
	
	
	@Override
	protected void doGet(final HttpServletRequest request, final HttpServletResponse response)
			throws IOException {
	
		addListeners();
		
		AuthManager.process(request, response);
		
		removeListeners();
	}

	@Override
	protected void doPost(final HttpServletRequest request, final HttpServletResponse response) 
			throws ServletException, IOException {
		addListeners();
		
		NotificationManager.process(request, response);
		
		removeListeners();
		
		
	}
	
	private void addListeners() {
		AuthManager.addOnNewUserListener(this);
		NotificationManager.addOnLocationChangeListener(this);
		NotificationManager.addOnMenuActionListener(this);
		NotificationManager.addOnTimelineChangeListener(this);
	}
	
	private void removeListeners() {
		AuthManager.removeOnNewUserListener(this);
		NotificationManager.removeOnLocationChangeListener(this);
		NotificationManager.removeOnMenuActionListener(this);
		NotificationManager.removeOnTimelineChangeListener(this);
	}	
	
	 /**
	  * 
	  * @param id
	  * @param item
	 * @throws IOException 
	  */
	public void sendResponse(final NotifyArgs item) throws IOException {
		// Notification sent from Glass
		Notification notification = item.notification;
			
		Mirror mirrorClient = MirrorClient.getMirror(item.user.credential);
		 
		// Determine what custom action was taken by the user
		String id = notification.getUserActions().get(0).getPayload();

			
		// Send update to timeline item to contact's glasses
		if (item != null) {
			mirrorClient.timeline().update(id, item.response).execute();
		}
	 }
}
