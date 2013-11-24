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
package com.solstice_mobile.smartoffice;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.api.client.http.ByteArrayContent;
import com.google.api.client.http.InputStreamContent;
import com.google.api.services.mirror.Mirror;
import com.google.api.services.mirror.model.TimelineItem;
import com.solstice.glass.auth.AuthManager;
import com.solstice.glass.util.MirrorClient;
import com.solstice.glass.util.WebUtil;

public class DashboardServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4153310490226349590L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		if( req.getParameter("operation").equals("canvas")) {
			TimelineItem item = new TimelineItem();
			InputStream input = new URL("http://glass-sols-only.appspot.com/static/video/Googleglass_Northernvideo.m4v").openStream();
			InputStreamContent media = new InputStreamContent("audio/mp4", input);
			MirrorClient.getMirror(AuthManager.getCredential(req)).timeline().insert(item, media).execute();
			
		}
		resp.sendRedirect(WebUtil.buildUrl(req, "/"));
	}
}
