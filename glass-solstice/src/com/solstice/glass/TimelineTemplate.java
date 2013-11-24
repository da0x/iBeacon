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

import java.util.Iterator;
import java.util.Vector;
import java.util.logging.Logger;

import com.google.api.client.util.Strings;

/**
 * 
 * @author Greg - http://google.com/+gregcullie
 * @author Henry - http://www.linkedin.com/in/oyuehen
 *
 */
public class TimelineTemplate {
	private static final Logger LOG = Logger.getLogger(TimelineTemplate.class.getSimpleName());

	private String id = "";
	private String body = "";
	private String html="";
	
	private String databinding = "";
	private String dyamicUIBinding = "";
	
	//Response to Handle;
	private Vector<ResponseItem> responseHandlers;
	
	//TODO: Temp...Delete******
	public String temporaryFileStringForTesting;
	public void setTemporaryFileStringForTesting(String _temporaryFileStringForTesting){
		temporaryFileStringForTesting=_temporaryFileStringForTesting;
	}
	//*******************
	
	public TimelineTemplate(String _id) {
		setId(_id);
		responseHandlers = new Vector<ResponseItem>();
	}

	public String getId() {
		return id;
	}

	private void setId(String id) {
		this.id = id;
	}

	public String getBody() {
		String value = Application.getAttribute(Application.TEMPLATE_PATH);
		
		if( !Strings.isNullOrEmpty(value)) {
			value += body;
		} else {
			value = body;
		}
		
		return value;
	}

	public void setBody(String file) {
		this.body = file;
	}

	public String getDatabinding() {
		return databinding;
	}
	
	public String getHtml() {
		String value = Application.getAttribute(Application.HTML_PATH);
		
		if( !Strings.isNullOrEmpty(value)) {
			value += html;
		} else {
			value = html;
		}
		return value;
	}

	public void setHtml(String html) {
		this.html = html;
	}

	public void setDatabinding(String databinding) {
		this.databinding = databinding;
	}

	public String getDyamicUIBinding() {
		return dyamicUIBinding;
	}

	public void setDyamicUIBinding(String dyamicUIBinding) {
		this.dyamicUIBinding = dyamicUIBinding;
	}
	public void addResponseFlowItem(ResponseItem response){
		
		//TODO make sure the ResponseFlowItem is actually in the template.  if not throw warning, they could still generate with UIDBinder
		responseHandlers.add(response);
	}
	
	/**
	 * Makes a system read call
	 * @return
	 */
	public String getTemplateFile(){
		//TODO read file
		return temporaryFileStringForTesting;
	}
	
	public String doTransformation(){
		//TODO Databinding and UIBinding
		String rawTemplate = getTemplateFile();
		
		return rawTemplate;
	}
	
	/*
	 * return null if not found;
	 */
	public ResponseItem getResponseFlowItem(String id){
		Iterator<ResponseItem> responses = responseHandlers.iterator();
		while (responses.hasNext()) {
			ResponseItem responseFlowItem = (ResponseItem) responses.next();
			if(responseFlowItem.getId().compareTo(id)==0){
				return responseFlowItem;
			}
		}
		
		LOG.info("Response flow id:"+id+" was not found.  check the application config.");
		return null;
	}
	
	@Override
	public String toString() {
		return super.toString() + "{id="+id+",file="+body+",databinding="+databinding+",dyamicUIBinding="+dyamicUIBinding+"response="+responseHandlers+"}";
	}
	
	
}
