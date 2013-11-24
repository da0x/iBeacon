package com.solstice.glass.util;

import java.io.IOException;
import java.util.HashMap;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.util.Strings;
import com.google.api.services.mirror.model.TimelineItem;

/**
 * 
 * @author henryoyuela
 *
 */
public class TimelineItemHolder {
	protected HashMap<String, String> mValues;
	protected TimelineItem mTimelineItem;

	public TimelineItemHolder() {
		mValues = new HashMap<String, String>();
	}
	
	public TimelineItem getTimelineItem() {
		return mTimelineItem;
	}

	public void setTimelineItem(final TimelineItem item) {
		this.mTimelineItem = item;
	}
	
	protected void updateHtml(final String key, final String value) {
		String html = this.mTimelineItem.getHtml();
		
		if( !Strings.isNullOrEmpty(html) && !Strings.isNullOrEmpty(value)) {
			mTimelineItem.setHtml(html.replace(key, value));
		} else {
			mTimelineItem.setHtml(html.replace(key, "  "));
		}
	}
	
	public void insert(final Credential credential) throws IOException {
		if( mTimelineItem != null ) {
			MirrorClient.insertTimelineItem(credential, mTimelineItem);
		} else {
			//TODO: Log Error
			
			throw new IOException();
		}
	}
}
