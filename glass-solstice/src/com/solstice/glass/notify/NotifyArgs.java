package com.solstice.glass.notify;

import com.google.api.services.mirror.model.Location;
import com.google.api.services.mirror.model.Notification;
import com.google.api.services.mirror.model.TimelineItem;
import com.solstice.glass.auth.User;


public class NotifyArgs {
	public Notification notification;
	public User user;
	public Location location;
	public TimelineItem sender;
	public TimelineItem response;
	public String actionId;
}
