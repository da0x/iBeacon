
package com.solstice.glass;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.logging.Logger;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * 
 * @author Greg - http://google.com/+gregcullie
 * @author Henry - http://www.linkedin.com/in/oyuehen
 *
 */
final class ApplicationParser extends DefaultHandler{
	
	
	private static final Logger LOG = Logger
			.getLogger(Application.class.getSimpleName());

	private TimelineTemplate tempTimelineTemplate;
	
	/**
	 * 
	 */
	public void parse() {
		// get a factory
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
			// get a new instance of parser
			SAXParser sp = spf.newSAXParser();

			// parse the file and also register this class for call backs
			FileInputStream appInputStream = new FileInputStream("WEB-INF/application-structure.xml");

			sp.parse(appInputStream, this);
		} catch (SAXException se) {
			LOG.severe(se.getStackTrace().toString());
			se.printStackTrace();
		} catch (ParserConfigurationException pce) {
			LOG.severe(pce.getStackTrace().toString());
			pce.printStackTrace();
		} catch (IOException ie) {
			LOG.severe(ie.getStackTrace().toString());
			ie.printStackTrace();
		}
	}

	/**
	 * 
	 * @param uri
	 * @param localName
	 * @param qName
	 * @param attributes
	 * @throws SAXException
	 */
	public void startElement(String uri, String localName, String qName,
			org.xml.sax.Attributes attributes) throws SAXException {
		// reset
		LOG.info("Start qName = " + qName);

		if( qName.equalsIgnoreCase("solstice:application") ) {
			Application.addNewAttribute(Application.CLIENT_ID, attributes.getValue(Application.CLIENT_ID));
			Application.addNewAttribute(Application.CLIENT_SECRET, attributes.getValue(Application.CLIENT_SECRET));
			Application.addNewAttribute(Application.TEMPLATE_PATH, attributes.getValue(Application.TEMPLATE_PATH));
			Application.addNewAttribute(Application.HTML_PATH, attributes.getValue(Application.HTML_PATH));
			Application.addNewAttribute(Application.APP_NAME, attributes.getValue(Application.APP_NAME));
			Application.addNewAttribute(Application.CALLBACK_URL, attributes.getValue(Application.CALLBACK_URL));
		} else if (qName.equalsIgnoreCase("solstice:template")) {
			// create a new instance of Template
			tempTimelineTemplate = new TimelineTemplate(
					attributes.getValue("id"));
			tempTimelineTemplate.setBody(attributes.getValue("body"));
			tempTimelineTemplate.setHtml(attributes.getValue("html"));
			
			/*TODO: Determine how to show this example
			tempTimelineTemplate.setDyamicUIBinding(attributes.getValue("dynamicUIBindingId"));
			tempTimelineTemplate.setDatabinding(attributes.getValue("dataBindingId"));
			*/
		} else if (qName.equalsIgnoreCase("solstice:response")) {
			// create a new instance of ResponseFlow
			tempTimelineTemplate.addResponseFlowItem(new ResponseItem(
					attributes.getValue("id"), attributes.getValue("templateID")));
		} else if( qName.equalsIgnoreCase("solstice:scope")) {
			Application.addNewScope(attributes.getValue("value"));
		}
	}

	/**
	 * 
	 * @param ch
	 * @param start
	 * @param length
	 * @throws SAXException
	 */
	public void characters(char[] ch, int start, int length)
			throws SAXException {
	}

	/**
	 * 
	 * @param uri
	 * @param localName
	 * @param qName
	 * @throws SAXException
	 */
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		LOG.info("End qName = " + qName);
		if (qName.equalsIgnoreCase("solstice:template")) {
			// add it to the list
			LOG.info("putting item in structure: "
					+ tempTimelineTemplate.toString());
			
			Application.addNewTempate(tempTimelineTemplate);
		}
	}
	
}

