<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      入职通知
     *      生成员工编码
     *
     *
     *      zys
     *      20210406
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行生成员工编码操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date date1 = new Date();
    String dqsj =df.format(date1);
    String sql="";
    try {
        sql="SELECT count(*) as count from workflow_requestbase where workflowid= "+workflowid+ " and createdate='"+dqsj+"'";
        new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行生成员工编码sql操作<<<<<<<<<"+sql);
        rs.execute(sql);
            while (rs.next()){
                int lsh;
                String lshh="";
                String lcsl= rs.getString("count");//当天时间流程数量
                lsh = Integer.parseInt(lcsl)+1;
                if(String.valueOf(lsh).length()<2){
                    lshh= "0"+lsh;
                }
                String ygbh = dqsj.replace("-","")+lshh;
                json.put("ygbh",ygbh);
            }
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>