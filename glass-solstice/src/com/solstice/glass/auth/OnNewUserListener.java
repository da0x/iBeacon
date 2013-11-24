package com.solstice.glass.auth;

import java.io.IOException;

public interface OnNewUserListener {
	public void onNewUser(final User args) throws IOException;
}
