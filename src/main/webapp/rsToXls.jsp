<%@ page
	language="java" 
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import=	"java.sql.*,
			java.io.*,
			jxl.*,
			jxl.write.*,
			java.util.Date,
			org.apache.log4j.Category,
			java.text.SimpleDateFormat,
			java.math.*"

	errorPage=""
%>
<%!
boolean rsToXls(String nomeFile, ResultSet rs, String tableName, double count){

Category logrsToXls = Category.getInstance("GEOCATALOGO");
try {
		String nomeFoglio=tableName;
		
		double maxExcelRows=65535;
		//double maxExcelRows=1000;

		WritableSheet sheet = null;
		BigDecimal countFogli = new BigDecimal(count/maxExcelRows);
		
		countFogli = countFogli.setScale(0, RoundingMode.UP);

		WritableFont fontCampi = new WritableFont(WritableFont.ARIAL, 9, WritableFont.BOLD, false); 
		WritableCellFormat fontCampiFormat = new WritableCellFormat (fontCampi); 

		WritableWorkbook workbook = Workbook.createWorkbook(new File(nomeFile));
		
		Label label=null;
		
		for(int idFoglio=1; idFoglio<=countFogli.intValue(); idFoglio++){
		
			if(idFoglio>1)
				sheet = workbook.createSheet(nomeFoglio+"_"+String.valueOf(idFoglio-1), idFoglio-1);
			else
				sheet = workbook.createSheet(nomeFoglio, idFoglio-1);

			for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){
				if(!rs.getMetaData().getColumnTypeName(j).equals("SDE.ST_GEOMETRY")){
					label = new Label(j-1, 0, rs.getMetaData().getColumnName(j),fontCampiFormat);
					sheet.addCell(label);
				}
			}

		}

	
		WritableFont fontDati = new WritableFont(WritableFont.ARIAL, 8); 
		WritableCellFormat fontDatiFormat = new WritableCellFormat (fontDati); 


		WritableCellFormat floatFormat = new WritableCellFormat (fontDati, NumberFormats.FLOAT); 
		WritableCellFormat intFormat = new WritableCellFormat (fontDati, NumberFormats.INTEGER); 
		
		DateFormat customDateFormat = new DateFormat ("dd MMM yyyy hh:mm:ss"); 
		WritableCellFormat dateFormat = new WritableCellFormat (fontDati, customDateFormat); 		
		
		int ii=1;
		int iii=0;
		while(rs.next()){
		
			BigDecimal value = new BigDecimal((double)ii/maxExcelRows);
			value = value.setScale(0, RoundingMode.UP);
			sheet=workbook.getSheet(value.intValue()-1);
		
			iii=(int)(ii-(maxExcelRows*(value.intValue()-1)));

			for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){

				if (rs.getObject(j)!=null && !rs.getMetaData().getColumnTypeName(j).equals("SDE.ST_GEOMETRY")) {
					if(rs.getMetaData().getColumnTypeName(j).equals("NUMBER")){
						
						jxl.write.Number number3 = null;
						switch (rs.getMetaData().getScale(j)){
							case 0: // INTEGER
								number3 = new jxl.write.Number(j-1, iii, (int)rs.getInt(j), intFormat); 
							break; //FLOAT
							
							default:
								number3 = new jxl.write.Number(j-1, iii, (double)rs.getFloat(j), floatFormat); 
						}

						sheet.addCell(number3); 
					
					} else {
						if(rs.getMetaData().getColumnTypeName(j).equals("DATE")){
							DateTime dateCell = new DateTime(j-1, iii, rs.getDate(j), dateFormat); 
							sheet.addCell(dateCell); 
						} else {
							label = new Label(j-1, iii, rs.getString(j), fontDatiFormat); 
							sheet.addCell(label); 
						}
					}
				}

			}
			ii++;

		}
		
		
		// FOGLIO METADATI
		sheet = workbook.createSheet("Struttura dati", countFogli.intValue()+1);
		
		label = new Label(0, 0, "Nome campo",fontCampiFormat);
		sheet.addCell(label);
		label = new Label(1, 0, "Tipo campo",fontCampiFormat);
		sheet.addCell(label);
		label = new Label(2, 0, "Descrizione",fontCampiFormat);
		sheet.addCell(label);


		for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){
			if(!rs.getMetaData().getColumnTypeName(j).equals("SDE.ST_GEOMETRY")){
				label = new Label(0, j, rs.getMetaData().getColumnName(j),fontDatiFormat);
				sheet.addCell(label);
			}
		}
		String descrizione="";
		for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){
			switch (rs.getMetaData().getColumnType(j)){

				case 12: //VARCHAR
					descrizione="Varchar"+" ["+rs.getMetaData().getColumnDisplaySize(j)+"]";
				break;
				
				case 2: //NUMBER
					switch (rs.getMetaData().getScale(j)){
						case 0: // INTEGER
							descrizione="Number" + " ["+rs.getMetaData().getPrecision(j)+",0]";
						break; //FLOAT
						default:
							descrizione="Float";
							//descrizione=rs.getMetaData().getColumnTypeName(j)+" ["+rs.getMetaData().getPrecision(j)+","+rs.getMetaData().getScale(j)+"]";
					}
				break;
				
				case 91: //DATA
					descrizione="Data";
				break;
				
				case 2002: // SHAPE
					descrizione="";
				break;
				
				default:
					descrizione = rs.getMetaData().getColumnType(j)+" - "+rs.getMetaData().getColumnTypeName(j)+" [dispsize:"+rs.getMetaData().getColumnDisplaySize(j)+",precision: "+rs.getMetaData().getPrecision(j)+",scale: "+rs.getMetaData().getScale(j)+"]";

			}			
			
			label = new Label(1, j, descrizione, fontDatiFormat);
			
			sheet.addCell(label);
		}
		for(int j=1; j<rs.getMetaData().getColumnCount()+1; j++){
			if(!rs.getMetaData().getColumnTypeName(j).equals("SDE.ST_GEOMETRY")){
				label = new Label(2, j, rs.getMetaData().getColumnLabel(j),fontDatiFormat);
				sheet.addCell(label);
			}
		}

		workbook.write();
		
		workbook.close(); 
		return true;
} catch(Exception e) { 
	logrsToXls.error("rsToXls Errore: "+e.getMessage());
	e.printStackTrace();
	return false;
}

}


%>