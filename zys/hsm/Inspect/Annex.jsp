<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行附件检索<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONArray jsonArray = new JSONArray();
    String mailid =request.getParameter("id");//邮件id
    String sql="select * from mailresourcefile where mailid = "+mailid;
    rs.execute(sql);
    String filePath = null;
    //Doc2PdfUtil doc2PdfUtil = new Doc2PdfUtil(OpenOfficeHost, OpenOfficePort);

        while (rs.next()){
            JSONObject Json = new JSONObject();
            String filename = rs.getString("filename");
            String fileid = rs.getString("id");
            Json.put("fileid",fileid);
            Json.put("filename",filename);
            jsonArray.add(Json);
        }



    JSONObject jsonObj = new JSONObject();
    jsonObj.put("code", 200);
    jsonObj.put("mag", "返回成功");
    jsonObj.put("mapList", jsonArray.toString());
    out.println(jsonObj.toString());
%>