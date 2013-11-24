package com.solstice.glass.auth;

import javax.servlet.http.HttpServletRequest;

import com.google.api.client.auth.oauth2.Credential;

public class User {
	public HttpServletRequest request;
	public String userId;
	public Credential credential;
}
