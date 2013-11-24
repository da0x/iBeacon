package com.solstice.glass.auth;

import java.util.List;

import com.google.api.client.auth.oauth2.CredentialStore;

public interface AuthCredentialStore extends CredentialStore {

	public List<String> listAllUsers();
}
