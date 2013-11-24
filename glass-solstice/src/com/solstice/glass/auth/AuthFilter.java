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
package com.solstice.glass.auth;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solstice.glass.Application;
import com.solstice.glass.util.WebUtil;

/**
 * A filter which ensures that prevents unauthenticated users from accessing the
 * web app
 * 
 * @author Jenny Murphy - http://google.com/+JennyMurphy
 * @author Henry - http://www.linkedin.com/in/oyuehen
 */
public class AuthFilter implements Filter {
	private static final Logger LOG = Logger.getLogger(AuthFilter.class
			.getSimpleName());

	public AuthCredentialStore getCredentialStore() {
		return new ListableAppEngineCredentialStore();
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {

		//Set the credential data store where all credentials will be stored for this session.
		AuthManager.setCredentialStore(getCredentialStore());
		
		if (response instanceof HttpServletResponse
				&& request instanceof HttpServletRequest) {
			HttpServletRequest httpRequest = (HttpServletRequest) request;
			HttpServletResponse httpResponse = (HttpServletResponse) response;

			// Redirect to https when on App Engine since subscriptions only
			// work over https
			if (httpRequest.getServerName().contains("appspot.com")
					&& httpRequest.getScheme().equals("http")) {

				httpResponse.sendRedirect(httpRequest.getRequestURL()
						.toString().replaceFirst("http", "https"));
				return;
			}

			String callbackURL = Application
					.getAttribute(Application.CALLBACK_URL);

			// Are we in the middle of an auth flow? IF so skip check.
			if (httpRequest.getServletPath().equals(callbackURL)) {
				LOG.info("Skipping auth check during auth flow");
				filterChain.doFilter(request, response);
				return;
			}

			LOG.fine("Checking to see if anyone is logged in");
			if (!AuthManager.isUserAuthenticated(httpRequest)) {
				// redirect to auth flow
				httpResponse.sendRedirect(WebUtil.buildUrl(httpRequest,
						callbackURL));
				return;
			}

			// Things checked out OK :)
			filterChain.doFilter(request, response);
		} else {
			LOG.warning("Unexpected non HTTP servlet response. Proceeding anyway.");
			filterChain.doFilter(request, response);
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void destroy() {
	}
}
