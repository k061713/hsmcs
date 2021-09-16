<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      培训管理接口
     *      培训申请人员数量统计
     *      zys
     *      2021323
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行培训申请人员数量统计操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs2 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String dx = request.getParameter("dx");//培训对象

    String sql="";
    try {
        String spq[] = dx.split("~");
        int sl=0;
        int sl1=0;
        int sl2=0;
        int sl3=0;
        int sl4=0;
        int sl5=0;
        int sl6=0;
        int zsl=0;

        String sid="";
        String sql1="";
        String sql2="";
        List<String> gr = new ArrayList<String>();
        List<String> gr1 = new ArrayList<String>();
        List<String> gr2 = new ArrayList<String>();
        List<String> gr3 = new ArrayList<String>();
        List<String> gr4 = new ArrayList<String>();
        List<String> gr5 = new ArrayList<String>();
        List<String> id1 = new ArrayList<String>();
        List<String> id2 = new ArrayList<String>();
        List<String> id3 = new ArrayList<String>();
        List<String> id4 = new ArrayList<String>();
        List<String> id5 = new ArrayList<String>();
        for (int i =0;i<spq.length;i++){

            String b1 = spq[i].toString();
            String fl = b1.substring(0,b1.indexOf("_"));
            String id= b1.substring(b1.indexOf("_")+1);
            sid = id.substring(0,id.indexOf("_"));
            new BaseBean().writeLog(">>>>>>>>>>>>>>id<<<<<<<<<"+sid);

            if(fl.equals("1")){
                //个人
                gr.add(sid);
            }
            if(fl.equals("2")){
                gr1.add(sid);//分部
            }
            if(fl.equals("3")){
                gr2.add(sid);//部门
            }
            if(fl.equals("4")){
                gr3.add(sid);//角色
            }
            if(fl.equals("5")){
                gr4.add(sid);//所有人
            }
            if(fl.equals("6")){
                gr5.add(sid);//岗位
            }

        }

        if(gr4.size()>0){
            sql1 = "SELECT count(id)as count FROM hrmresource";//所有人
            sql2 = "SELECT id FROM hrmresource";
            rs.execute(sql1);
            rs2.execute(sql2);
            while (rs2.next()){
                id4.add(rs2.getString("id"));
            }
            while (rs.next()){
                sl6 = Integer.valueOf(rs.getString("count"));
            }
            zsl=sl6;
        }else{
            if(gr.size()>0){
                String grobj =gr.toString().replace("[","(").replace("]", ")");
                sql1 = "SELECT count(id)as count FROM hrmresource where id in"+grobj;//人员

                rs.execute(sql1);

                while (rs.next()){
                    sl = Integer.valueOf(rs.getString("count"));
                }
            }
            String obj1="";
            if(gr1.size()>0) {
                obj1 =gr1.toString().replace("[","(").replace("]", ")");//分部id
                if(gr.size()==0) {//人员类型为空
                    sql1="SELECT count(id)as count FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1;
                    sql2="SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1;
                }else {
                    String obj =gr.toString().replace("[","(").replace("]", ")");

                    sql1="SELECT count(id)as count FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and id not in"+obj;//分部
                    sql2="SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and id not in"+obj;
                }

                rs.execute(sql1);
                rs2.execute(sql2);
                while (rs2.next()){
                    id1.add(rs2.getString("id"));
                    new BaseBean().writeLog("当前执行的分部语句分部："+sql2);
                }
                while (rs.next()){
                    sl1 = Integer.valueOf(rs.getString("count"));
                    new BaseBean().writeLog("分部sql1："+sql1);
                }

            }
            String obj2="";
            if(gr2.size()>0) {//部门
                obj2 =gr2.toString().replace("[","(").replace("]", ")");

                if(gr.size()==0) {
                    if (!obj1.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE departmentid in"+obj2+" and SUBCOMPANYID1 !="+obj1;
                        sql2="SELECT id FROM hrmresource WHERE departmentid in"+obj2+" and SUBCOMPANYID1 not in"+obj1;
                    }else {
                        sql1="SELECT count(id)as count FROM hrmresource WHERE departmentid in"+obj2;
                        sql2="SELECT id FROM hrmresource WHERE departmentid in"+obj2;
                    }

                }else {
                    String obj =gr.toString().replace("[","(").replace("]", ")");
                    if (!obj1.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE departmentid in"+obj2+" and SUBCOMPANYID1 not in"+obj1+" and id not in"+obj;//部门
                        sql2="SELECT id FROM hrmresource WHERE departmentid in"+obj2+" and id not in"+obj+" and SUBCOMPANYID1 not in"+obj1;
                    }else {
                        sql1="SELECT count(id)as count FROM hrmresource WHERE departmentid in"+obj2+" and id not in"+obj;//部门
                        sql2="SELECT id FROM hrmresource WHERE departmentid in"+obj2+" and id not in"+obj;
                    }

                }
                new BaseBean().writeLog("当前执行的语句部门："+sql1);
                rs.execute(sql1);
                rs2.execute(sql2);
                while (rs2.next()){
                    id2.add(rs2.getString("id"));
                }
                while (rs.next()){
                    sl2 = Integer.valueOf(rs.getString("count"));
                    new BaseBean().writeLog("当前部门sl2："+sql1);
                }
            }
            String obj3="";
            if(gr3.size()>0){
                obj3 =gr3.toString().replace("[","(").replace("]", ")");//角色id

                if(gr.size()==0) {
                    if(!obj1.equals("")&&obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+")";
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+")";
                    }else if (!obj1.equals("")&&!obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and departmentid in"+obj2+")";
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and departmentid in"+obj2+")";
                    }else if (obj1.equals("")&&!obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE  departmentid in"+obj2+")";
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE departmentid in"+obj2+")";
                    }else{
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3;
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3;
                    }
                }else {
                    String obj =gr.toString().replace("[","(").replace("]", ")");
                    if(!obj1.equals("")&&obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+")"+" and resourceid not in"+obj;
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+")"+" and resourceid not in"+obj;
                    }else if (!obj1.equals("")&&!obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and departmentid in"+obj2+")"+" and resourceid not in"+obj;
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE SUBCOMPANYID1 in"+obj1+" and departmentid in"+obj2+")"+" and resourceid not in"+obj;
                    }else if (obj1.equals("")&&!obj2.equals("")){
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE  departmentid in"+obj2+")"+" and resourceid not in"+obj;
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and RESOURCEID not in("+"SELECT id FROM hrmresource WHERE departmentid in"+obj2+")"+" and resourceid not in"+obj;
                    }else{
                        sql1="SELECT count(id)as count FROM hrmrolemembers WHERE roleid in"+obj3+" and resourceid not in"+obj;//角色
                        sql2="SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+" and resourceid not in"+obj;
                    }



                }
                rs.execute(sql1);
                rs2.execute(sql2);
                while (rs2.next()){

                    id3.add(rs2.getString("RESOURCEID"));
                    new BaseBean().writeLog("当前角色sql2："+sql2);
                }
                while (rs.next()){
                    sl3 = Integer.valueOf(rs.getString("count"));
                    new BaseBean().writeLog("当前角色sql1："+sql1);
                }
            }
            if(gr5.size()>0) {//岗位
                String obj5 =gr5.toString().replace("[","(").replace("]", ")");

                if(gr.size()==0) {
                    if(!obj1.equals("")&&obj2.equals("")&&obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1;
                    }else if (!obj1.equals("")&&!obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and departmentid not in"+obj2+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")";
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and departmentid not in"+obj2;
                    }else if (obj1.equals("")&&!obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")";
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2;
                    }else if (obj1.equals("")&&obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")";
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2;
                    }else {
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5;
                    }

                }else {
                    String obj =gr.toString().replace("[","(").replace("]", ")");
                    if(!obj1.equals("")&&obj2.equals("")&&obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and id not in"+obj;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and id not in"+obj;
                    }else if (!obj1.equals("")&&!obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and departmentid not in"+obj2+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")"+" and id not in"+obj;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and SUBCOMPANYID1 not in"+obj1+" and departmentid not in"+obj2+" and id not in"+obj;
                    }else if (obj1.equals("")&&!obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")"+" and id not in"+obj;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2+" and id not in"+obj;
                    }else if (obj1.equals("")&&obj2.equals("")&&!obj3.equals("")){
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and id not in("+"SELECT RESOURCEID FROM hrmrolemembers WHERE roleid in"+obj3+")"+" and id not in"+obj;
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and departmentid not in"+obj2+" and id not in"+obj;
                    }else {
                        sql1="SELECT count(id)as count FROM hrmresource WHERE jobtitle in"+obj5+" and id not in"+obj+" and id not in"+obj;//岗位
                        sql2="SELECT id FROM hrmresource WHERE jobtitle in"+obj5+" and id not in"+obj;
                    }
                }
                new BaseBean().writeLog("当前执行的语句："+sql1);
                rs.execute(sql1);
                rs2.execute(sql2);
                while (rs2.next()){
                    id5.add(rs2.getString("id"));
                }
                while (rs.next()){
                    sl5 = Integer.valueOf(rs.getString("count"));
                    new BaseBean().writeLog("当前sl5："+sl5);
                }
            }
            new BaseBean().writeLog("当前sl："+sl+",sl1:"+sl1+",sl2:"+sl2+",sl3:"+sl3+",sl5:"+sl5+",sl6:"+sl6);
            zsl = sl+sl1+sl2+sl3+sl5+sl6;
            gr.addAll(id1);
            gr.addAll(id2);
            gr.addAll(id3);
            gr.addAll(id4);
            gr.addAll(id5);
            new BaseBean().writeLog("当前执行的结果id："+gr+",id;"+gr1+",id;"+gr2+",id;"+gr3+",id;"+gr5);

        }
        json.put("sid", gr.toString());
        json.put("zsl", zsl);
        new BaseBean().writeLog("当前执行的结果："+jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>