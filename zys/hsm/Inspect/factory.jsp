<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *    检查工厂 zys
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行检验工厂接口操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String sql="";
    try {
        if (workflowid.equals("276")){
            sql="select * from uf_rcjcjl";//日常检查记录 jcxm jcnr jcqy
        }else if (workflowid.equals("321")){
            sql="select * from uf_xfjcnr";//消防检查内容 jcxm jcnr
        }else if(workflowid.equals("319")){
            sql="select * from uf_5sjcnr";//5S检查内容 jcxm jcnr
        }else if(workflowid.equals("315")){
            sql="select * from uf_lqkzxt";//利器控制系统审核 jcxm jcnr
        }else if(workflowid.equals("318")){
            sql="select * from uf_xcglhjqr";//现场管理检验环境确认 xcxm
        }
        String jcxm="";
        String jcnr="";
        String jcqy="";
        new BaseBean().writeLog("当前执行的语句："+sql+",页面id："+workflowid);
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            if(workflowid.equals("318")){
                jcxm = rs.getString("xcxm");
            }else {
                if(workflowid.equals("276")){
                    jcqy = rs.getString("jcqy");
                }
                jcxm = rs.getString("jcxm");
                jcnr = rs.getString("jcnr");
            }
            Json.put("jcxm",jcxm);
            Json.put("jcnr",jcnr);
            Json.put("jcqy",jcqy);
            jsonArray.add(Json);
        }

        json.put("currentPage", 1);
        json.put("totalPage", 1);
        json.put("mapList", jsonArray.toString());
        new BaseBean().writeLog("当前执行的结果："+jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.println(json.toString());
%>