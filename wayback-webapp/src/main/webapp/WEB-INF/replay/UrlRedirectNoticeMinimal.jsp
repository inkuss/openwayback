<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.lang.StringBuffer"%>
<%@ page import="org.archive.wayback.archivalurl.ArchivalUrlDateRedirectReplayRenderer"%>
<%@ page import="org.archive.wayback.ResultURIConverter"%>
<%@ page import="org.archive.wayback.archivalurl.ArchivalUrl"%>
<%@ page import="org.archive.wayback.core.UIResults"%>
<%@ page import="org.archive.wayback.core.WaybackRequest"%>
<%@ page import="org.archive.wayback.core.CaptureSearchResult"%>
<%@ page import="org.archive.wayback.util.StringFormatter"%>
<%@ page import="org.archive.wayback.util.url.UrlOperations"%>

<%
UIResults results = UIResults.extractReplay(request);

WaybackRequest wbr = results.getWbRequest();
StringFormatter fmt = wbr.getFormatter();
CaptureSearchResult cResult = results.getResult();
ResultURIConverter uric = results.getURIConverter();

String sourceUrl = cResult.getOriginalUrl();
String targetUrl = cResult.getRedirectUrl();
String captureTS = cResult.getCaptureTimestamp();
if(targetUrl.equals("-")) {
	Map<String,String> headers = results.getResource().getHttpHeaders();
	Iterator<String> headerNameItr = headers.keySet().iterator();
	while(headerNameItr.hasNext()) {
	       String name = headerNameItr.next();
	       if(name.toUpperCase().equals("LOCATION")) {
	    	    targetUrl = headers.get(name);
	            // by the spec, these should be absolute already, but just in case:
	            targetUrl = UrlOperations.resolveUrl(sourceUrl, targetUrl);
	    	    
	    	    
	       }
	}
}
// TODO: Handle replay if we still don't have a redirect..
ArchivalUrl aUrl = new ArchivalUrl(wbr);
String dateSpec = aUrl.getDateSpec(captureTS);
String targetReplayUrl = uric.makeReplayURI(dateSpec,targetUrl);
String safeTargetReplayUrlJS = fmt.escapeJavaScript(targetReplayUrl);

%>
	<script type="text/javascript">
        window.location.replace("<%= safeTargetReplayUrlJS %>");
	</script>
