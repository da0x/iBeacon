/*
 * Copyright (C) 2013 Greg Cullen
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.solstice.glass;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.logging.Logger;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import com.google.api.client.util.Strings;
import com.google.api.services.mirror.model.NotificationConfig;
import com.google.api.services.mirror.model.TimelineItem;
import com.solstice.glass.auth.AuthManager;
import com.solstice.glass.auth.User;
import com.solstice.glass.util.CommonUtil;
import com.solstice.glass.util.MirrorClient;

/**
 * A pattern for managing templates and decisions trees
 * 
 * Template, Response, DataDelegate
 * 
 * @author Greg - http://google.com/+gregcullie
 * @author Henry - http://www.linkedin.com/in/oyuehen
 */

final public class Application  {
	public static String APP_NAME = "name";
	public static String CLIENT_ID = "clientID";
	public static String CLIENT_SECRET = "clientSecret";
	public static String TEMPLATE_PATH = "templatePath";
	public static String HTML_PATH = "htmlPath";
	public static String CALLBACK_URL = "callbackUrl";
	/**
	 * 
	 */
	private static final Logger LOG = Logger.getLogger(Application.class.getSimpleName());
	/**
	 * 
	 */
	private static Application instance;
	/**
	 * 
	 */
	protected HashMap<String, TimelineTemplate> mAppStructure;
	/**
	 * 
	 */
	protected HashMap<String, String> mAttrs;
	/**
	 * 
	 */
	private StringBuilder mScope;
	
	
	static {
		instance = new Application();
		
		// Read and parse application-structure.xml file
		ApplicationParser parser = new ApplicationParser();
		parser.parse();
	}
	
	/**
	 * 
	 */
	private Application() {		
		mAppStructure = new HashMap<String, TimelineTemplate>();
		mAttrs = new HashMap<String, String>();
		mScope = new StringBuilder();
	}

	/**
	 * 
	 * @param tlTemplateToAdd
	 */
	public static void addNewTempate(TimelineTemplate tlTemplateToAdd) {
		instance.mAppStructure.put(tlTemplateToAdd.getId(), tlTemplateToAdd);
	}
	
	/**
	 * 
	 * @param scope
	 */
	public static void addNewScope(String scope) {
		/**Verify a valid value is provided*/
		if( !Strings.isNullOrEmpty(scope) ) {
			if( instance.mScope == null) {
				instance.mScope = new StringBuilder();
			} else {
				instance.mScope.append(" ");
			}
			
			instance.mScope.append(scope);
		}
	}
	
	/**
	 * 
	 * @param id
	 * @param value
	 */
	public static void addNewAttribute(String id, String value){
		if(!Strings.isNullOrEmpty(id) && !Strings.isNullOrEmpty(value)) {
			if( instance.mAttrs == null ) {
				instance.mAttrs = new HashMap<String, String>();
			}
			
			instance.mAttrs.put(id, value);
		}
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	public static String getAttribute(String id) {
		return instance.mAttrs.get(id);
	}
	
	/**
	 * 
	 * @return
	 */
	 public static String getScope() {
		 return instance.mScope.toString();
	 }

	/**
	 * gets an new template.
	 * 
	 * @param templateId
	 * @return
	 */
	public static TimelineItem getTimelineItem(String templateId) {
		LOG.info("Getting Timeline for update templateid=" + templateId);
		LOG.info("retrieving file:"
				+ instance.mAppStructure.get(templateId).getBody()
				+ " for tempate id:" + templateId);

		// Read template file
		ObjectMapper mapper = new ObjectMapper();

		try {
			TimelineTemplate template = instance.mAppStructure.get(templateId);
			TimelineItem templateTimelineItem = mapper.readValue(new File(
					template.getBody()), TimelineItem.class);
			// Triggers an audible tone when the timeline item is received
			templateTimelineItem.setNotification(new NotificationConfig().setLevel("DEFAULT"));
			
			// Read html associated with this time line item if there is any
			if (!Strings.isNullOrEmpty(template.getHtml())) {
				templateTimelineItem.setHtml(CommonUtil.readFileAsString(template
						.getHtml()));
			}

			LOG.info("template timeline retrieved:" + templateTimelineItem);
			return templateTimelineItem;
		} catch (JsonParseException e) {
			LOG.severe(e.toString());
			e.printStackTrace();
		} catch (JsonMappingException e) {
			LOG.severe(e.toString());
			e.printStackTrace();
		} catch (IOException e) {
			LOG.severe(e.toString());
			e.printStackTrace();
		} catch (Exception e) {
			LOG.severe(e.toString());
			e.printStackTrace();
		}

		throw new RuntimeException();
	}


	/**
	 * This will look through all the flows for the actionid/notificationId in
	 * any target
	 * 
	 * @param notificationId
	 * @return
	 */
	public static String getTargetTemplateForUserAction(String notificationId) {
		LOG.info("Searching for responseFlowId:" + notificationId);
		
		Collection<TimelineTemplate> keys = instance.mAppStructure.values();
		for (Iterator<TimelineTemplate> iterator = keys.iterator(); iterator
				.hasNext();) {
			TimelineTemplate timelineTemplate = (TimelineTemplate) iterator.next();
			
			ResponseItem foundResponseFlow = timelineTemplate.getResponseFlowItem(notificationId);
			
			
			if (foundResponseFlow != null) {
				LOG.info("Found response flow item " + foundResponseFlow
						+ " for notificationId:" + notificationId);
				// found firstTemplate with this response id
				return foundResponseFlow.getTemplateId();
			}
		}

		LOG.severe("The notification response flow id '" + notificationId
				+ "' was not found");
		return null;
	}
	
	/**
	 * This will look through all the flows for the actionid/notificationId in
	 * any target
	 * 
	 * @param notificationId
	 * @return
	 */
	public static TimelineItem getTimelineItemForUserAction(String notificationId) {
		LOG.info("Searching for responseFlowId:" + notificationId);
		
		Collection<TimelineTemplate> keys = instance.mAppStructure.values();
		for (Iterator<TimelineTemplate> iterator = keys.iterator(); iterator
				.hasNext();) {
			TimelineTemplate timelineTemplate = (TimelineTemplate) iterator.next();
			
			ResponseItem foundResponseFlow = timelineTemplate.getResponseFlowItem(notificationId);
			
			
			if (foundResponseFlow != null) {
				LOG.info("Found response flow item " + foundResponseFlow
						+ " for notificationId:" + notificationId);
				// found firstTemplate with this response id
				return getTimelineItem(foundResponseFlow.getTemplateId());
			}
		}

		LOG.severe("The notification response flow id '" + notificationId
				+ "' was not found");
		return null;
	}

	/**
	 * 
	 * @param responseText
	 * @return
	 */
	 public static String findTemplateWithTheResponse(String responseText){
		 //TODO: Define implementation
		 return "";
	 }
	
	 
	 public static String getHtmlContent(String filename) throws IOException {
		 return CommonUtil.readFileAsString(Application.getAttribute(Application.HTML_PATH) +filename);
	 }
	 
	 
	 public static void patchTimeline(final User user, String itemId, TimelineItem item) throws IOException {
		MirrorClient.getMirror(AuthManager.getCredential(user.request)).timeline().patch(itemId, item).execute();	
	}
	
}
