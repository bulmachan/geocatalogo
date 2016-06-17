<%@ page
	language="java" 
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	errorPage=""
%><%@ include file="configDB.jsp"
%><%@ include file="params.jsp"
%><%

String layer=request.getParameter("table");
String table=layer.split("\\.")[0]+"."+layer.split("\\.")[1];
String nome=request.getParameter("nome");
String layerid = request.getParameter("layerid");

Statement stmc = null;
ResultSet rPub = null;
int countPub = 0;
try	{
	String stmtt_Sql = "";
	stmtt_Sql = "select count(*) as c from CAT_USER.CAT_V_TREE where ord=2 and id="+layerid+" and pubflag=3";
	//out.println(stmtt_Sql);
	
	stmc = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rPub = stmc.executeQuery(stmtt_Sql);
	rPub.next();
	countPub = rPub.getInt("c");
	rPub.close();
	stmc.close();
	
} catch(Exception eee) {
	out.print(eee.getMessage());
	eee.printStackTrace();
}
//out.print(countPub);
%>  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>Tabella</title>



<!-- Combo-handled YUI CSS files: -->  
<!-- Combo-handled YUI JS files: -->  
<script type="text/javascript" src="http://yui.yahooapis.com/2.7.0/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="http://yui.yahooapis.com/2.7.0/build/connection/connection-min.js"></script>
<script type="text/javascript" src="http://yui.yahooapis.com/2.7.0/build/element/element-min.js"></script>

<script type="text/javascript" src="http://yui.yahooapis.com/2.7.0/build/datasource/datasource-min.js"></script>
<script type="text/javascript" src="js/yui.yahooapis.com/2.7.0/build/datatable/datatable-min.js"></script>
<script type="text/javascript" src="js/funzioniAjax.js"></script>

<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.7.0/build/fonts/fonts-min.css" />
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.7.0/build/paginator/assets/skins/sam/paginator.css" />
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.7.0/build/datatable/assets/skins/sam/datatable.css" />

<script type="text/javascript" src="js/yui.yahooapis.com/2.7.0/build/paginator/paginator.js"></script>
<link rel="stylesheet" type="text/css" href="styles/style_page.css" />
 </head>
<body class="yui-skin-sam">
<script type="text/javascript">
	/*<![CDATA[*/
	
	function download(){
		
		document.getElementById("download_loading").style.display="block";
		//prompt("",'downloadXls.jsp?table=<%=table%>&nome=<%=nome%>');
		xmlAjaxRequest('downloadXls.jsp', 'table=<%=table%>&nome='+escape(decodeURI('<%=nome%>')), null, showsResults, 'text');

	}
	
	function showsResults(result){
		if (result){
			if(result.indexOf("ERRORE")>-1){

				document.getElementById("download_txt").innerHTML="<p>Attenzione: non e' stato possibile preparare il file per il download. Riprovare pi&ugrave; tardi.<\/p>";

			} else {
				file=result.split("<|>")[0];
				siz=result.split("<|>")[1];

				document.getElementById("download_txt").innerHTML="<p>File generato e pronto per il <a href='<%=outputURL%>"+file+"' >download<\/a> ("+Math.round(siz/1024)+" Kb)<\/p>";
				document.getElementById("download").style.display="none";
				parent.writeGeoLog('download table','<%=layerid%>');

			}
			document.getElementById("download_loading").style.display="none";
			document.getElementById("download_txt").style.display="block";
		}
	}
/*]]>*/
</script>
 <div id="main">
 
  <div id="titolo">
	<strong><%="Tabella di "+nome%></strong>&nbsp;&nbsp;
<% if(countPub>0){
%>	
	<span id="download">
		<a href="javascript:download()" title="Scarica l'intera tabella in formato XLS (Excel)"><img src="images/download.png" alt="Scarica l'intera tabella in formato XLS (Excel)" /></a>
	</span>
<% }
%>
	<span id="download_txt" class="tit_3 display_none">Attendere l'estrazione dei dati<br /></span>
	<span id="download_loading" class="display_none"><br /><img alt="Estrazione dei dati in corso..." src="images/ajax-loader.gif" /></span>
	
  </div>
  <br />
  <div id="dynamicdata"></div>
  <div id="pag-below"></div>
</div>

<%
Statement stm = null;
ResultSet rCount = null;
ResultSet rs = null;
try	{

	stm = dbConnCAT.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

	rCount = stm.executeQuery("SELECT COUNT(*) AS rowcount FROM "+table);
	rCount.next();
	int count = rCount.getInt("rowcount") ;
	rCount.close() ;

	String stmt_Sql = "select * from "+table;

	rs = stm.executeQuery(stmt_Sql);
	
	// SCELTA DEL CAMPO PER ORDINAMENTO iniziale (default=il primo campo non Shape): 
	String sortField=rs.getMetaData().getColumnName(1).toLowerCase();
	
	for(int j=1; j<rs.getMetaData().getColumnCount(); j++){
		if(!rs.getMetaData().getColumnTypeName(j).equals("SDE.ST_GEOMETRY")){
			sortField=rs.getMetaData().getColumnName(j).toLowerCase();
			sortField = sortField.substring(0, 1).toUpperCase() + sortField.substring(1, sortField.length()).toLowerCase();
			break;
		}
	}
	
	String f = "";
%>


<script type="text/javascript">
/*<![CDATA[*/
	// Custom parser
    var stringToDate = function(sData) {
        var array = sData.split("-");
        return new Date(array[1] + " " + array[0] + ", " + array[2]);
    };

YAHOO.example.DynamicData = function() {
    // Column definitions
    myColumnDefs = [ // sortable:true enables sorting
<%	for(int j=1; j<rs.getMetaData().getColumnCount(); j++){
		
		f = rs.getMetaData().getColumnName(j);
		f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();
		
		if(rs.getMetaData().getColumnTypeName(j).equals("NUMBER")){
			out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true},");
		} else {
			if(rs.getMetaData().getColumnTypeName(j).equals("DATE")){
			out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true, formatter:\"date\"},");
			} else {
			out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true},");
			}
		}
	}
	
	f = rs.getMetaData().getColumnName(rs.getMetaData().getColumnCount());
	f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();

	if(rs.getMetaData().getColumnTypeName(rs.getMetaData().getColumnCount()).equals("NUMBER")){
		out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true}");
	} else {
		if(rs.getMetaData().getColumnTypeName(rs.getMetaData().getColumnCount()).equals("DATE")){
		out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true, formatter:\"date\"}");
		} else {
		out.println("\t\t\t{key:\""+ f +"\", label:\""+ f +"\", sortable:true}");
		}
	}
%>
	];

    
    // DataSource instance
    var myDataSource = new YAHOO.util.DataSource("getTableData.jsp?table=<%=layer%>&nome="+escape(decodeURI('<%=nome%>'))+"&totCount=<%=count%>&layerid=<%=layerid%>&");
    myDataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
    myDataSource.responseSchema = {
        resultsList: "records",
        fields: [
<%	for(int j=1; j<rs.getMetaData().getColumnCount(); j++){

		f = rs.getMetaData().getColumnName(j);
		f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();
		
		if(rs.getMetaData().getColumnTypeName(j).equals("NUMBER")){
			if(f.equalsIgnoreCase("SHAPE"))
				out.println("\t\t\t{key:\""+ f +"\", parser:\"text\"},");
			else
				out.println("\t\t\t{key:\""+ f +"\", parser:\"number\"},");

		} else {
			if(rs.getMetaData().getColumnTypeName(j).equals("DATE")){
				out.println("\t\t\t{key:\""+ f +"\", parser:stringToDate},");
			} else {
			out.println("\t\t\t{key:\""+ f +"\"},");
			}
		}
	}
	
	f = rs.getMetaData().getColumnName(rs.getMetaData().getColumnCount());
	f = f.substring(0, 1).toUpperCase() + f.substring(1, f.length()).toLowerCase();

	if(rs.getMetaData().getColumnTypeName(rs.getMetaData().getColumnCount()).equals("NUMBER")){
		if(f.equalsIgnoreCase("SHAPE"))
			out.println("\t\t\t{key:\""+ f +"\", parser:\"text\"}");
		else
			out.println("\t\t\t{key:\""+ f +"\", parser:\"number\"}");
	} else {
		if(rs.getMetaData().getColumnTypeName(rs.getMetaData().getColumnCount()).equals("DATE")){
			out.println("\t\t\t{key:\""+ f +"\", parser:stringToDate}");
		} else {
		out.println("\t\t\t{key:\""+ f +"\"}");
		}
	}
	
%>	
        ],
        metaFields: {
            totalRecords: "totalRecords" // Access to value in the server response
        }
    };
    
    var myPaginator = {
		rowsPerPage:10,
	    firstPageLinkLabel : "<< ",   
		firstPageLinkClass : "yui-pg-first", // default   
   
		// Options for LastPageLink component   
		lastPageLinkLabel : " >>",   
		lastPageLinkClass : "yui-pg-last", // default   
  
		previousPageLinkLabel : "< ",   
		previousPageLinkClass : "yui-pg-previous",   

		nextPageLinkLabel : " >", // default   
	    nextPageLinkClass : "yui-pg-next", // default   
		containers : [ "pag-below" ]
	}
	
	// DataTable configuration
    var myConfigs = {
        initialRequest: "sort=<%=sortField%>&dir=asc&startIndex=0&results=10", // Initial request for first page of data
        dynamicData: true, // Enables dynamic server-driven data
        sortedBy : {key:"<%=sortField%>", dir:YAHOO.widget.DataTable.CLASS_ASC}, // Sets UI initial sort arrow
        paginator: new YAHOO.widget.Paginator(myPaginator) // Enables pagination 
    };
    //prompt("","getTableData.jsp?table=<%=layer%>&nome="+escape(decodeURI('<%=nome%>'))+"&totCount=<%=count%>&layerid=<%=layerid%>&"+"sort=<%=sortField%>&dir=asc&startIndex=0&results=10");
    // DataTable instance
    var myDataTable = new YAHOO.widget.DataTable("dynamicdata", myColumnDefs, myDataSource, myConfigs);
    // Update totalRecords on the fly with value from server
    myDataTable.handleDataReturnPayload = function(oRequest, oResponse, oPayload) {
        oPayload.totalRecords = oResponse.meta.totalRecords;
        return oPayload;
    }
    	
    return {
        ds: myDataSource,
        dt: myDataTable
    };
        
}();
/*]]>*/
</script>

<%
	rs.close();
	stm.close();

	dbConnCAT.close();

} catch(Exception ee) {
	out.print(ee.getMessage());
	ee.printStackTrace();

	if(rCount!=null)
		rCount.close();

	if(rs!=null)
		rs.close();

	if(stm!=null)
		stm.close();
	
	dbConnCAT.close();
}
%>
 <script type="text/javascript">
/*<![CDATA[*/
	parent.writeGeoLog('open table','<%=layerid%>');
 /*]]>*/
</script>
 </body>
</html>
