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
import java.util.Collections;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.extensions.appengine.http.UrlFetchTransport;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.mirror.model.Subscription;
import com.solstice.glass.Application;
import com.solstice.glass.util.MirrorClient;
import com.solstice.glass.util.WebUtil;

/**
 * A collection of utility functions that simplify common authentication and
 * user identity tasks
 * 
 * @author Jenny Murphy - http://google.com/+JennyMurphy
 * @author Henry - http://www.linkedin.com/in/oyuehen
 */
final public class AuthManager {
	private static final Logger LOG = Logger.getLogger(AuthManager.class
			.getSimpleName());

	private static AuthCredentialStore credentialStore = new ListableAppEngineCredentialStore();
	
	public static void setCredentialStore(final AuthCredentialStore store) {
		if( store != null ) {
			credentialStore = store;
		} else {
			//TODO: Add Log
		}
	}
	
	/**
	 * Creates and returns a new {@link AuthorizationCodeFlow} for this app.
	 */
	public static AuthorizationCodeFlow newAuthorizationCodeFlow() throws IOException {
		String clientId = Application.getAttribute(Application.CLIENT_ID);
		String clientSecret = Application
				.getAttribute(Application.CLIENT_SECRET);

		return new GoogleAuthorizationCodeFlow.Builder(new UrlFetchTransport(),
				new JacksonFactory(), clientId, clientSecret,
				Collections.singleton(Application.getScope()))
				.setAccessType("offline").setCredentialStore(credentialStore).build();
	}

	public static void addOnNewUserListener(final OnNewUserListener listener) {
		OnNewUserVisitor.instance.add(listener);
	}

	public static void removeOnNewUserListener(final OnNewUserListener listener) {
		OnNewUserVisitor.instance.remove(listener);
	}

	/**
	 * Get the current user's ID from the session
	 * 
	 * @return string user id or null if no one is logged in
	 */
	public static String getUserId(final HttpServletRequest request) {
		HttpSession session = request.getSession();
		return (String) session.getAttribute("userId");
	}

	public static void setUserId(final HttpServletRequest request,
			final String userId) {
		HttpSession session = request.getSession();
		session.setAttribute("userId", userId);
	}

	public static void clearUserId(final HttpServletRequest request) throws IOException {
		// Delete the credential in the credential store
		String userId = getUserId(request);
		credentialStore.delete(userId, getCredential(userId));

		// Remove their ID from the local session
		request.getSession().removeAttribute("userId");
	}

	public static Credential getCredential(String userId) throws IOException {
		if (userId == null) {
			return null;
		} else {
			return AuthManager.newAuthorizationCodeFlow()
					.loadCredential(userId);
		}
	}

	public static Credential getCredential(HttpServletRequest req)
			throws IOException {
		return AuthManager.newAuthorizationCodeFlow().loadCredential(
				getUserId(req));
	}

	public static boolean isUserAuthenticated(HttpServletRequest request)
			throws IOException {
		return !((AuthManager.getUserId(request) == null
				|| AuthManager.getCredential(AuthManager.getUserId(request)) == null || AuthManager
				.getCredential(AuthManager.getUserId(request)).getAccessToken() == null));
	}

	private static void createSubscription(HttpServletRequest req, User user)
			throws IOException {
		try {
			String[] scopes = Application.getScope().split(" ");

			for (String scope : scopes) {
				// Subscribe for timeline updates
				if ("https://www.googleapis.com/auth/glass.timeline"
						.equals(scope)) {
					// Subscribe to timeline updates
					String callbackUrl = WebUtil.buildUrl(req,
							Application.getAttribute(Application.CALLBACK_URL));

					Subscription subscription = MirrorClient
							.insertSubscription(user.credential, callbackUrl,
									user.userId, "timeline");

					LOG.info("Inserted subscription " + subscription.getId()
							+ " for user " + user.userId + " timeline");
				}
				// Subscribe for location updates
				else if ("https://www.googleapis.com/auth/glass.location"
						.equals(scope)) {
					// Subscribe to timeline updates
					String callbackUrl = WebUtil.buildUrl(req,
							Application.getAttribute(Application.CALLBACK_URL));

					Subscription subscription = MirrorClient
							.insertSubscription(user.credential, callbackUrl,
									user.userId, "location");

					LOG.info("Inserted subscription " + subscription.getId()
							+ " for user " + user.userId + " location");
				}
			}

		} catch (GoogleJsonResponseException e) {
			LOG.warning("Failed to create timeline subscription. Might be running on "
					+ "localhost. Details:" + e.getDetails().toPrettyString());
		}
	}

	public static void process(final HttpServletRequest request,
			final HttpServletResponse response) throws IOException {

		// If something went wrong, log the error message.
		if (request.getParameter("error") != null) {
			LOG.severe("Something went wrong during auth: "
					+ request.getParameter("error"));

			response.setContentType("text/plain");

			response.getWriter().write(
					"Authentication error: " + request.getParameter("error"));
		}
		// If we have a code, finish the OAuth 2.0 dance
		else if (request.getParameter("code") != null) {
			LOG.info("Got a code. Attempting to exchange for access token.");

			AuthorizationCodeFlow flow = AuthManager.newAuthorizationCodeFlow();
			TokenResponse tokenResponse = flow
					.newTokenRequest(request.getParameter("code"))
					.setRedirectUri(
							WebUtil.buildUrl(request, request.getServletPath()))
					.execute();

			// Extract the Google User ID from the ID token in the auth response
			String userId = ((GoogleTokenResponse) tokenResponse)
					.parseIdToken().getPayload().getUserId();

			LOG.info("Code exchange worked. User " + userId + " logged in.");

			// Set it into the session
			AuthManager.setUserId(request, userId);
			flow.createAndStoreCredential(tokenResponse, userId);

			User user = new User();
			user.request = request;
			user.userId = userId;

			// Fetch the current user credentials form the credential store,
			// needed for updating timeline
			user.credential = AuthManager.newAuthorizationCodeFlow()
					.loadCredential(userId);

			createSubscription(request, user);

			OnNewUserVisitor.instance.visitObservers(user);

			// Redirect back to index
			response.sendRedirect(WebUtil.buildUrl(request, "/"));

		}
		// Else, we have a new flow. Initiate a new flow.
		else {
			LOG.info("No auth context found. Kicking off a new auth flow.");

			AuthorizationCodeFlow flow = AuthManager.newAuthorizationCodeFlow();
			GenericUrl url = flow.newAuthorizationUrl().setRedirectUri(
					WebUtil.buildUrl(request, request.getServletPath()));
			url.set("approval_prompt", "force");
			response.sendRedirect(url.build());
		}
	}
}
