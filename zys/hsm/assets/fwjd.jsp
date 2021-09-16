<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      线索分配接口
     *      zys
     *      20210203
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行线索分配操作<<<<<<<<<");
    RecordSet rs = new RecordSet();

    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    User users1 = HrmUserVarify.getUser(request, response);
    //String workflowid = request.getParameter("workflowid");

    String billid = request.getParameter("billid");//线索id
    String xs = request.getParameter("xs");//
    String sql="";

    try {
            if(xs.equals("0")){
                sql = "select * from uf_xsk where id="+billid ;//分配销售员
            }else if(xs.equals("1")) {
                sql = "select * from uf_khgl where id="+billid ;//分配销售员
            }
        new BaseBean().writeLog(">>>>>>>>>>>>>>执行1<<<<<<<<<"+sql);
        rs.execute(sql);
        while (rs.next()){
            String fwjd = rs.getString("fwjd");
            String xsfpr = rs.getString("xsfpr");
            String fpzt = rs.getString("fpzt");
            json.put("code", 200);
            json.put("fwjd",fwjd);
            json.put("xsfpr",xsfpr);
            json.put("fpzt",fpzt);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());

%>