<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    //参数获取，链接传参
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    String time1  = request.getParameter("time1");
    String country1  = request.getParameter("country1");
    String country2 = request.getParameter("country2");
    JSONObject jsonObject = new JSONObject();
    int sc=0;
    int sc1=0;
    SimpleDateFormat df= new SimpleDateFormat("yyyy-mm-dd");
    Date  currdate = df.parse(time1);
    BaseBean baseBean = new BaseBean();
    try {
        String sql="select id,gj,sc from uf_gj where id='"+country1;
        String sql1="select id,gj,sc from uf_gj where id='"+country2;
        String sql2="select id,gj,sc from uf_gj where id in（'"+country1+"','"+country2+"')";
        rs.execute(sql);
        while (rs.next()){
            sc= Integer.valueOf(rs.getString("sc"));
        }
        rs1.execute(sql1);
        while (rs1.next()){
            sc1=Integer.valueOf(rs1.getString("sc"));
        }
        int sb =sc1-sc;
        Calendar c = Calendar.getInstance();
        c.setTime(currdate);
        c.add(Calendar.HOUR, sb);
        jsonObject.put("result",df.format(c.getTime()));
        jsonObject.put("resultMessage","当前时差计算完毕");
    } catch (NumberFormatException e) {
        jsonObject.put("result","202");
        jsonObject.put("resultMessage","当前时差计算出错");
        e.printStackTrace();
    }
    out.clear();
    out.print(jsonObject);
%>



