<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="weaver.formmode.setup.ModeRightInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      潜在/正式客户分配接口
     *      zys
     *      20210203
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行正式/潜在客户分配操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    User users1 = HrmUserVarify.getUser(request, response);
    String ryid = request.getParameter("ryid");//现分配的人员id
    String dm = request.getParameter("dm");//客户代码
    String khqc = request.getParameter("khqc");//客户全称
    String yxs = request.getParameter("yxs");//原销售
    String xxs = request.getParameter("xxs");//现销售
    String id = request.getParameter("billid");//客户id

    String fwjd = request.getParameter("fwjd");//服务阶段 12：潜在客户公海，15：正式客户公海
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date1 = new Date();
    String modedatacreatedate=df.format(date1).substring(0,df.format(date1).indexOf(" "));
    String modedatacreatetime=df.format(date1).substring(df.format(date1).lastIndexOf(" ")+1);
    String uuid = UUID.randomUUID().toString();
    String sql="";
    String sql1="";
    String sql2="";
    String sql3="";
    try {
        sql1 ="select * from hrmresource where id = "+ryid;//分配人员信息
        rs1.execute(sql1);
        while (rs1.next()){
            String ssbm =rs1.getString("departmentid");//所属部门
            String ssjg =rs1.getString("subcompanyid1");//所属机构
            String xdm ="P"+dm.substring(dm.lastIndexOf("-"));
            new BaseBean().writeLog(">>>>>>>>>>>>>>服务阶段<<<<<<<<<"+fwjd);
            if(fwjd.equals("12")){
                String czlx ="00008";
                //sql2 ="INSERT INTO uf_zyjlb (khid,zysj,modedatacreatedate,modedatacreatetime,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,yxsdb,xxsdb) VALUES ('"+id+"','"+df.format(date1)+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+6+"','"+11+"','"+czlx+"','"+users1.getUID()+"','"+dm+"','"+xdm+"','"+khqc+"','"+yxs+"','"+xxs+"')";
                sql2 ="INSERT INTO uf_zyjlb (khid,zysj,formmodeid,modedatacreatedate,modedatacreatetime,uuid,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,xkhqc,yxsdb,xxsdb) VALUES ('"+id+"','"+df.format(date1)+"','"+112+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+uuid+"','"+6+"','"+11+"','"+czlx+"','"+users1.getUID()+"','"+dm+"','"+xdm+"','"+khqc+"','"+khqc+"','"+yxs+"','"+ryid+"')";
                sql = "update uf_khgl set xxs ="+ryid + ",ssbm ='"+ssbm+"' ,ssjg='"+ssjg+"',ywgsjg='"+ssjg+"',fwjd='"+11+"', khdm='"+xdm+"' WHERE id = "+id ; //分配潜在客户
                sql3 ="SELECT COUNT(xxs) FROM uf_khgl WHERE xxs="+ryid;
                rs3.execute(sql3);
                while (rs3.next()){
                    int count =rs3.getInt("COUNT");
                    if(count<300){
                        boolean bo =  rs.execute(sql);
                        if (bo){
                            rs2.execute(sql2);
                            ModeRightInfo ModeRightInfo = new ModeRightInfo();
                            ModeRightInfo.setNewRight(true);
                            ModeRightInfo.editModeDataShare(Integer.parseInt(ryid),3,Integer.parseInt(id));
                            json.put("code", 200);
                            json.put("msg","更新分配成功！");
                        }else {
                            json.put("code", 201);
                            json.put("msg","更新分配失败！");
                        }
                    }else {
                        json.put("code", 202);
                        json.put("msg","分配数超300！");
                    }
                }

            }else if(fwjd.equals("15")){
                String czlx ="00010";
                String zdm ="F"+dm.substring(dm.lastIndexOf("-"));
                //sql2 ="INSERT INTO uf_zyjlb (khid,zysj,modedatacreatedate,modedatacreatetime,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,yxsdb,xxsdb) VALUES ('"+id+"','"+df.format(date1)+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+9+"','"+18+"','"+czlx+"','"+users1.getUID()+"','"+dm+"','"+xdm+"','"+khqc+"','"+yxs+"','"+xxs+"')";
                sql2 ="INSERT INTO uf_zyjlb (khid,zysj,formmodeid,modedatacreatedate,modedatacreatetime,uuid,zylx1,fwjd,czlx,zyczz,ykhdm,xkhdm,ykhqc,xkhqc,yxsdb,xxsdb) VALUES ('"+id+"','"+df.format(date1)+"','"+112+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+uuid+"','"+9+"','"+18+"','"+czlx+"','"+users1.getUID()+"','"+dm+"','"+zdm+"','"+khqc+"','"+khqc+"','"+yxs+"','"+ryid+"')";
                sql = "update uf_khgl set xxs="+ryid + ",ssbm ='"+ssbm+"' ,ssjg='"+ssjg+"',ywgsjg='"+ssjg+"',fwjd='"+18+"', khdm='"+zdm+"' WHERE id = "+id ; //分配潜在客户
                boolean bo =  rs.execute(sql);
                if (bo){
                    rs2.execute(sql2);
                    ModeRightInfo ModeRightInfo = new ModeRightInfo();
                    ModeRightInfo.setNewRight(true);
                    ModeRightInfo.editModeDataShare(Integer.parseInt(ryid),3,Integer.parseInt(id));
                    json.put("code", 200);
                    json.put("msg","分配成功！");

                }else {
                    json.put("code", 201);
                    json.put("msg","分配失败！");
                }
            }else {
                json.put("code", 203);
                json.put("msg","分配失败！服务阶段不符合");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());

%>

<%!
    public String CodingChanges(String fwjd){
        String year ="2021";
        String month= "03";
        String jgxh ="JD";



        return null;
    }

%>