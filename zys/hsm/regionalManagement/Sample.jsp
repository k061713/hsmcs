<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      样板接口
     *      zys
     *      20210204
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行样板接口操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();

    String cfwz = request.getParameter("cfwz");//存放位置
    String sql="";
    try {
        //sql="SELECT * FROM formtable_main_406_dt1";
        sql="SELECT * FROM view_formtable WHERE cfwz="+cfwz+" and sl!=''";//入库明细
        String ybmc ="";//样板名称
        String ybkhbm="";//样板客户编码
        String 	sl= "";//数量
        String 	xhgg="";//型号规格
        String 	kh= "";//款号
        String ybly="";//样板来源
        new BaseBean().writeLog("当前执行的语句："+sql+",存放位置："+cfwz);
        rs.execute(sql);
            while (rs.next()){
                JSONObject Json = new JSONObject();
                ybmc = rs.getString("ybmc");
                ybkhbm = rs.getString("ybkhbm");
                kh = rs.getString("kh");
                sl = rs.getString("sl");
                Json.put("ybmc",ybmc);
                Json.put("ybkhbm",ybkhbm);
                Json.put("xhgg",xhgg);
                Json.put("kh",kh);
                Json.put("sl",sl);
                jsonArray.add(Json);
            }
        json.put("mapList", jsonArray.toString());
        //new BaseBean().writeLog("当前执行的结果："+jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>