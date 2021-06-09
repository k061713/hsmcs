<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
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
    RecordSet rs1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    User users1 = HrmUserVarify.getUser(request, response);
    //String workflowid = request.getParameter("workflowid");
    String ryid = request.getParameter("ryid");//所分配的人员id
    String dm = request.getParameter("dm");//客户代码
    String khqc = request.getParameter("khqc");//客户全称
    String yxs = request.getParameter("yxs");//原销售
    String xxs = request.getParameter("xxs");//现销售
    String billid = request.getParameter("billid");//线索id

    String lx = request.getParameter("lx");//类型 0：分配权限转移，1：分配线索（分配销售员）
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date1 = new Date();
    String modedatacreatedate=df.format(date1).substring(0,df.format(date1).indexOf(" "));
    String modedatacreatetime=df.format(date1).substring(df.format(date1).lastIndexOf(" ")+1);
    String uuid = UUID.randomUUID().toString();
    String sql="";
    String sql1="";
    String sql2="";
    try {


        sql1 ="INSERT INTO uf_zyjlb (khid,zysj,formmodeid,modedatacreatedate,modedatacreatetime,uuid,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,xkhqc,yxsdb,xxsdb) VALUES ('"+billid+"','"+df.format(date1)+"','"+112+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+uuid+"','"+1+"','"+10+"','"+1+"','"+users1.getUID()+"','"+dm+"','"+dm+"','"+khqc+"','"+khqc+"','"+yxs+"','"+ryid+"')";
        sql2 ="select * from hrmresource where id = "+ryid;//分配人员信息
        rs2.execute(sql2);
        while (rs2.next()) {
            String ssbm = rs2.getString("departmentid");//所属部门
            String ssjg = rs2.getString("subcompanyid1");//所属机构

            if (lx.equals("0")){
                sql = "update uf_xsk set xsfpr ="+ryid + " WHERE id = '"+billid+"'" ; //分配权限
            }else {
                sql = "update uf_xsk set xxs ="+ryid + ",xsfpr =null "+",fpzt =0"+",ssjg='"+ssjg+"',ssbm='"+ssbm+"' WHERE id = '"+billid+"'" ;//分配销售员
            }
            new BaseBean().writeLog(">>>>>>>>>>>>>>执行1<<<<<<<<<"+sql);
            boolean jg=rs.execute(sql);
            if (jg){
                new BaseBean().writeLog(">>>>>>>>>>>>>>执行2<<<<<<<<<"+sql1+",分配人："+ryid);
                if (lx.equals("1")){
		            rs1.execute(sql1);
		        }
                ModeRightInfo ModeRightInfo = new ModeRightInfo();
                ModeRightInfo.setNewRight(true);
                ModeRightInfo.editModeDataShare(Integer.parseInt(ryid),22,Integer.parseInt(billid));
		        json.put("code", 200);
                json.put("msg","分配成功！");
            }else {
                json.put("code", 201);
                json.put("msg","分配失败！");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());

%>