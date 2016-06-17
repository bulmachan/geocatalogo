<%@ page import="java.util.zip.*"
%><%
class  makeZipFile {
	
	public makeZipFile(){
	}
	
	public void doZip(String path, String filename, Integer fileSize, String pathDoc, String fileDoc) {
        try {

			byte[] buf = new byte[fileSize];
            FileInputStream fis = new FileInputStream(path+filename+".xls");
            fis.read(buf,0,buf.length);
            
            CRC32 crc = new CRC32();
            ZipOutputStream s = new ZipOutputStream((OutputStream)new FileOutputStream(path+filename+".zip"));
            
            s.setLevel(6);
            ZipEntry entry = new ZipEntry(filename+".xls");
            entry.setSize((long)buf.length);
            crc.reset();
            crc.update(buf);
            entry.setCrc( crc.getValue());
            s.putNextEntry(entry);
            s.write(buf, 0, buf.length);

			if(fileDoc!=null && pathDoc!=null){
				File file = new File(pathDoc+fileDoc);
				long len = file.length();
				Integer fileSizeDoc=Integer.valueOf((int)len);
				byte[] buf1 = new byte[fileSizeDoc];
		        FileInputStream fis1 = new FileInputStream(pathDoc+fileDoc);
			    fis1.read(buf1,0,buf1.length);
				CRC32 crc1 = new CRC32();
				ZipEntry entryDoc = new ZipEntry(fileDoc);
				entryDoc.setSize((long)buf1.length);
				crc1.reset();
				crc1.update(buf1);
				entryDoc.setCrc( crc1.getValue());
				s.putNextEntry(entryDoc);
				s.write(buf1, 0, buf1.length);
			}
			
			s.finish();
            s.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
%>