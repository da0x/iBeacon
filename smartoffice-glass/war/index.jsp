<!--
Copyright (C) 2013 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<%@ page import="com.google.api.client.auth.oauth2.Credential" %>
<%@ page import="com.google.api.services.mirror.model.Contact" %>
<%@ page import="com.google.api.services.mirror.model.TimelineItem" %>
<%@ page import="com.google.api.services.mirror.model.Subscription" %>
<%@ page import="com.google.api.services.mirror.model.Attachment" %>
<%@ page import="java.util.List" %>
<%@ page import="com.solstice.glass.util.MirrorClient" %>
<%@ page import="com.solstice.glass.util.WebUtil" %>
<%@ page import="com.solstice.glass.auth.AuthManager" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!doctype html>
<%
  String userId = AuthManager.getUserId(request);
  String appBaseUrl = WebUtil.buildUrl(request, "/");
  Credential credential = AuthManager.getCredential(userId);
%>
<html>
	<body>
		 <form action="<%= WebUtil.buildUrl(request, "/dashxface") %>" method="post">
	        <input type="hidden" name="operation" value="canvas">
	        <button class="btn" type="submit">Simulate Canvas Viewing</button>
	     </form>
	</body>
</html>
