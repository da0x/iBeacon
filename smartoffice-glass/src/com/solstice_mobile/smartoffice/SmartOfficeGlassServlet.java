package com.solstice_mobile.smartoffice;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Random;

import com.google.api.client.http.InputStreamContent;
import com.google.api.services.mirror.model.TimelineItem;
import com.solstice.glass.Application;
import com.solstice.glass.ApplicationServlet;
import com.solstice.glass.auth.AuthManager;
import com.solstice.glass.auth.User;
import com.solstice.glass.notify.NotifyArgs;
import com.solstice.glass.util.BundleBuilder;
import com.solstice.glass.util.MirrorClient;
import com.solstice.glass.util.TimelineItemHolder;

public class SmartOfficeGlassServlet extends ApplicationServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void onMenuAction(NotifyArgs args) throws IOException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onLocationChange(NotifyArgs args) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTimelineChange(NotifyArgs args) {
		
	}

	@Override
	public void onNewUser(User args) throws IOException {

		Random id = new Random(Long.MAX_VALUE);
		
		BundleBuilder bundle = new BundleBuilder("smartoffice-welcome-bundle" +id.nextInt());
		
		TimelineItem mTimelineItem = new TimelineItem();
		mTimelineItem = Application.getTimelineItem("welcome_card");
		
		TimelineItemHolder item = new TimelineItemHolder();
		item.setTimelineItem(mTimelineItem);
		bundle.addTimeLineItem(item, true);
							
		mTimelineItem = Application.getTimelineItem("mobile_insight");
		item.setTimelineItem(mTimelineItem);
		bundle.addTimeLineItem(item, false);
		
		mTimelineItem = Application.getTimelineItem("my_info");
		item.setTimelineItem(mTimelineItem);
		bundle.addTimeLineItem(item, false);
		
		mTimelineItem = Application.getTimelineItem("explore_solstice");
		item.setTimelineItem(mTimelineItem);
		bundle.addTimeLineItem(item, false);

		mTimelineItem = Application.getTimelineItem("general_info");
		item.setTimelineItem(mTimelineItem);
		bundle.addTimeLineItem(item, false);
		
		
		//Send Welcome bundle to current user's glass
		bundle.insert(args.credential);

	}

}
