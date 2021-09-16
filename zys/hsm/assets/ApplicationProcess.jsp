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
     *      申购流程接口
     *      zys
     *      20210412
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行申购流程操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    User users1 = HrmUserVarify.getUser(request, response);
    //String workflowid = request.getParameter("workflowid");

    String billid = request.getParameter("billid");//线索id
    String xs = request.getParameter("xs");//
    String sql="";

    try {
        sql="INSERT INTO uf_zyjlb (khid,zysj,formmodeid,modedatacreatedate,modedatacreatetime,uuid,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,xkhqc,yxsdb,xxsdb) VALUES ('"+billid+"','"+df.format(date1)+"','"+112+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+uuid+"','"+1+"','"+10+"','"+1+"','"+users1.getUID()+"','"+dm+"','"+dm+"','"+khqc+"','"+khqc+"','"+yxs+"','"+ryid+"')";
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());

%>