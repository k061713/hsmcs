<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="weaver.interfaces.workflow.action.hrm.MapComparator" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行附件检索<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONArray jsonArray = new JSONArray();
    String mailid =request.getParameter("id");//邮件id
    String sql="select * from mailresourcefile where mailid = "+mailid;
    rs.execute(sql);
    while (rs.next()){
        JSONObject Json = new JSONObject();
        String filename = rs.getString("filename");
        String filerealpath = rs.getString("filerealpath");

        Json.put("filename",filename);
        Json.put("filerealpath",filerealpath);
        jsonArray.add(Json);
    }
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("code", 200);
    jsonObj.put("mag", "返回成功");
    jsonObj.put("mapList", jsonArray.toString());
    out.println(jsonObj.toString());
%>