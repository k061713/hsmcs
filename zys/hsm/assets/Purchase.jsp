<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      资产管理明细接口
     *      zys
     *      2021126
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行资产接口操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String zcmc = request.getParameter("zcmc");//资产名称
    String zclx = request.getParameter("zclx");
    String sql="";
    try {

            if(!zcmc.equals("")&&!zclx.equals("")){
                sql="select * from formtable_main_41_dt1 where zclx="+zclx+" and zcmc= "+zcmc ;//资产入库明细
            }else if (workflowid.equals("67")){
                sql="select * from formtable_main_41_dt1 where zclx!=3";//资产入库明细
            }else if(workflowid.equals("144")){
                sql="select * from formtable_main_41_dt1 where zclx=3";//资产入库明细/利器
            }

        //String zcmc="";//资产名称
        String sl="";//数量
        String bz="";//备注
        new BaseBean().writeLog("当前执行的语句："+sql+",页面id："+workflowid);
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            zcmc = rs.getString("zcmc");
            sl = rs.getString("sl");
            bz = rs.getString("bz");
            Json.put("zcmc",zcmc);
            Json.put("sl",sl);
            Json.put("bz",bz);
            jsonArray.add(Json);
        }

        json.put("mapList", jsonArray.toString());
        new BaseBean().writeLog("当前执行的结果："+jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    //out.clear();
    out.println(json.toString());


%>