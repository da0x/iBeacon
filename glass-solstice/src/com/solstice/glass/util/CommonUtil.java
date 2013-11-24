package com.solstice.glass.util;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class CommonUtil {
	/**
	 * Method used to read the contents of a file and convert to a string
	 * object.
	 * 
	 * @param filePath
	 * @return
	 * @throws IOException
	 */
	public static String readFileAsString(String filePath) throws IOException {
		DataInputStream dis = new DataInputStream(new FileInputStream(filePath));
		try {
			long len = new File(filePath).length();
			if (len > Integer.MAX_VALUE)
				throw new IOException("File " + filePath + " too large, was "
						+ len + " bytes.");
			byte[] bytes = new byte[(int) len];
			dis.readFully(bytes);
			return new String(bytes, "UTF-8");
		} finally {
			dis.close();
		}
	}
}
