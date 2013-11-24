
package com.solstice.glass;


/**
 * 
 * @author Greg - http://google.com/+gregcullie
 * @author Henry - http://www.linkedin.com/in/oyuehen
 *
 */
public class ResponseItem {
	private String id;
	private String templateId;
	
	public ResponseItem(String _id, String _templateId) {
		id = _id;
		templateId = _templateId;
	}
	
	public String getId(){
		return id;
	}

	public String getTemplateId() {
		return templateId;
	}
	
	@Override
	public String toString() {
		return super.toString() +"{id="+id+",templateId="+templateId;
	}
}
