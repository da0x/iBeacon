package com.solstice.glass.notify;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Writer;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.mirror.Mirror;
import com.google.api.services.mirror.model.Location;
import com.google.api.services.mirror.model.Notification;
import com.google.api.services.mirror.model.UserAction;
import com.solstice.glass.Application;
import com.solstice.glass.auth.AuthManager;
import com.solstice.glass.auth.User;
import com.solstice.glass.util.MirrorClient;


final public class NotificationManager {
	private static final Logger LOG = Logger.getLogger(NotificationManager.class
			.getSimpleName());
	
	private NotificationManager() {
	}
	
	public static void addOnTimelineChangeListener(OnTimelineChangeListener listener){
		OnTimelineChangeVisitor.instance.add(listener);
	}
	
	public static void removeOnTimelineChangeListener(OnTimelineChangeListener listener) {
		OnTimelineChangeVisitor.instance.remove(listener);
	}
	
	public static void addOnLocationChangeListener(OnLocationChangeListener listener) {
		OnLocationChangeVisitor.instance.add(listener);
	}
	
	public static void removeOnLocationChangeListener(OnLocationChangeListener listener) {
		OnLocationChangeVisitor.instance.remove(listener);
	}
	
	public static void addOnMenuActionListener(OnMenuActionListener listener){
		OnMenuActionVisitor.instance.add(listener);
	}
	
	public static void removeOnMenuActionListener(OnMenuActionListener listener) {
		OnMenuActionVisitor.instance.remove(listener);
	}
	
	
	public static boolean process(HttpServletRequest request, HttpServletResponse response) throws IOException {
		boolean processed = false;
		
		NotifyArgs args = new NotifyArgs();
		
		// Respond with OK and status 200 in a timely fashion to prevent
		// redelivery
		response.setContentType("text/html");
		Writer writer = response.getWriter();
		writer.append("OK");
		writer.close();

		// Get the notification object from the request body (into a string so
		// we can log it)
		BufferedReader notificationReader = new BufferedReader(new InputStreamReader(request.getInputStream()));
		String notificationString = "";
		while (notificationReader.ready()) {
			notificationString += notificationReader.readLine();
		}

		LOG.info("got raw notification " + notificationString);

		JsonFactory jsonFactory = new JacksonFactory();

		// If logging the payload is not as important, use
		// jacksonFactory.fromInputStream instead.
		Notification notification = jsonFactory.fromString(notificationString,
				Notification.class);

		LOG.info("Got a notification with ID: " + notification.getItemId());

		// Figure out the impacted user and get their credentials for API calls
		args.user = new User();
		args.user.request = request;
		args.user.userId = notification.getUserToken();
		args.user.credential = AuthManager.getCredential(args.user.userId);
		Mirror mirrorClient = MirrorClient.getMirror(args.user.credential);

		if (notification.getCollection().equals("locations")) {
			LOG.info("Notification of updated location");
			Mirror glass = MirrorClient.getMirror(args.user.credential);
			
			// item id is usually 'latest'
			Location location = glass.locations().get(notification.getItemId())
					.execute();

			args.location = location;
			
			OnLocationChangeVisitor.instance.visitObservers(args);
			
			LOG.info("New location is " + location.getLatitude() + ", "
					+ location.getLongitude() + " with an accuracy of:"
					+ location.getAccuracy());
			
			processed = true;			
		} else if (notification.getCollection().equals("timeline")) {
			// Get the impacted timeline item
			args.sender = mirrorClient.timeline().get(notification.getItemId()).execute();
			
			LOG.info("Notification impacted timeline item with ID: "+ args.sender.getId());
			
			if ( notification.getUserActions().contains(new UserAction().setType("CUSTOM")) ) {
				// Determine what custom action was taken by the user
				args.actionId = notification.getUserActions().get(0).getPayload();

				// Fetch the template with the matching actionId
				args.response = Application.getTimelineItemForUserAction(args.actionId); 	
				
				OnMenuActionVisitor.instance.visitObservers(args);
						
			} else {
				OnTimelineChangeVisitor.instance.visitObservers(args);
				
			}
			
			processed = true;
		}
		
		return processed;
	}
	
}
