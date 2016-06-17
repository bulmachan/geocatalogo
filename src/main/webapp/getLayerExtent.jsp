<%@ page
	language="java" 
	contentType="text/html; charset=iso-8859-1"
	pageEncoding="ISO8859-1"
	errorPage=""
%><%@ include file="configESRI.jsp"
%><%@ include file="classes/micSpatialEngine.jsp"
%><%
	
	String[] layerParams=request.getParameter("layer").split("\\.");
	String owner="";
	String layer="";
	String type="polygon";
	String expression="";

	if(layerParams.length > 0){
		owner=layerParams[0];
		if(layerParams.length > 1)
			layer=layerParams[1];
		if(layerParams.length>2)
			type=layerParams[2];
		if(layerParams.length>3)
			expression=layerParams[3];
	}

	try{
		micSpatialEngine mSE = new micSpatialEngine(connUser,connPw,nomeServer,portaSDE);
		
		mSE.apriConnSDE();

		if(expression.equals("")){
			out.print(mSE.stringaExtentLayer(owner+"."+layer, "SHAPE"));
		} else {
			mSE.trovaElementoPerParametri(owner+"."+layer, "upper("+expression.split("=")[0]+")"+"="+"upper('"+expression.split("=")[1]+"')");
			//out.println(mSE.statusReport);
			String sdeExtent = mSE.stringaExtentElemento();
			out.print(sdeExtent);
		}
		mSE.chiudiConnSDE();
	} catch(Exception e){
		e.printStackTrace();
		out.println("Errore");
	}

%>
