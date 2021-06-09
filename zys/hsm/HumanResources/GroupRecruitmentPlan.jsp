<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      集团招聘计划接口
     *      zys
     *      20210407
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行集团招聘计划操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String jhzpnf = request.getParameter("jhzpnf");//年份

    String sql="";
    try {
        sql="select * from uf_jtzpjhdjb where jhzpnf="+jhzpnf;//
        //String zcmc="";//资产名称
        String id ="";//id
        String lcbm="";//流程编码
        String szjg="";//所属机构
        String szbm="";//所属部门
        String nzpgw="";//拟招聘岗位
        String nzpzw="";//拟招聘职务
        String nzpzwlb="";//拟招聘职务类别
        String nzprs="";//拟招聘人数
        String jhwcrq="";//计划完成日期
        String bz="";//备注
        new BaseBean().writeLog("当前执行的语句："+sql+",页面id："+workflowid);
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            id = rs.getString("id");
            lcbm = rs.getString("lcbm");
            szjg = rs.getString("szjg");
            szbm = rs.getString("szbm");
            nzpgw = rs.getString("nzpgw");
            nzpzw = rs.getString("nzpzw");
            nzpzwlb = rs.getString("nzpzwlb");
            nzprs = rs.getString("nzprs");
            jhwcrq = rs.getString("jhwcrq");
            bz = rs.getString("bz");
            Json.put("id",id);
            Json.put("lcbm",lcbm);
            Json.put("szjg",szjg);
            Json.put("szbm",szbm);
            Json.put("nzpgw",nzpgw);
            Json.put("nzpzw",nzpzw);
            Json.put("nzpzwlb",nzpzwlb);
            Json.put("nzprs",nzprs);
            Json.put("jhwcrq",jhwcrq);
            Json.put("bz",bz);
            jsonArray.add(Json);
        }

        json.put("mapList", jsonArray.toString());
        new BaseBean().writeLog("当前执行的结果："+jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>