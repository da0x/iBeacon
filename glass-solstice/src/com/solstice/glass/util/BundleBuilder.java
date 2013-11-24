package com.solstice.glass.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.mirror.model.TimelineItem;

public class BundleBuilder {
	private final String mBundleId;
	private List<TimelineItem> mTimelineItems;
	
	public BundleBuilder (String bundleId) {
		mBundleId = bundleId;
		mTimelineItems = new ArrayList<TimelineItem>();
	}
	
	public void addTimeLineItem(final TimelineItemHolder item, boolean isCover) {
		TimelineItem timelineItem = item.getTimelineItem();
	
		timelineItem.setBundleId(mBundleId);
		timelineItem.setIsBundleCover(isCover);
		
		mTimelineItems.add(timelineItem);	
	}
	
	public void insert(Credential credential) throws IOException {					
	    Iterator<TimelineItem> iter = mTimelineItems.iterator();
		while( iter.hasNext() ) {
			TimelineItem item = iter.next();
			MirrorClient.insertTimelineItem(credential, item);
		}
	}
}
