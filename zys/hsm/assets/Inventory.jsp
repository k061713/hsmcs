<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      资产盘点接口
     *      zys
     *      20210203
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行盘点接口操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String ckmc = request.getParameter("ckmc");//仓库名称
    String zclx = request.getParameter("zclx");//资产类型
    String ckgly = request.getParameter("ckgly");//仓库管理员
    String sql="";
    try {
       if(workflowid.equals("245")){
            sql="SELECT * FROM uf_gdzc WHERE ckmc="+ckmc+" AND zclx="+zclx+" AND ckgly="+ckgly+" and sfbf =1";//资产盘点
        }else if(workflowid.equals("284")){
            sql="SELECT * FROM uf_gdzc WHERE ckmc="+ckmc+" AND zclx="+zclx;//利器盘点
        }else if(workflowid.equals("125")){
           sql="SELECT * FROM uf_dzyhpkjmbd WHERE kcsl!=0";//低值易耗品盘点
       }
        String zcmc="";//资产名称
        String pm ="";
        String bz="";//备注
        String zcbh= "";//资产编码
        String ggxh="";//规格型号
        String bgy= "";//保管员
        String kcsl="";//库存数量
        String zczt="";//资产状态
        String id="";//易耗品id
        String jldw1="";//易耗品单位
        new BaseBean().writeLog("当前执行的语句："+sql+",页面id："+workflowid);
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            if(workflowid.equals("245")){
                bgy = rs.getString("bgy");
            }else if(workflowid.equals("125")){
                pm = rs.getString("pm");

                kcsl = rs.getString("kcsl");
                jldw1 = rs.getString("jldw1");

            }
            id= rs.getString("id");
            zcbh = rs.getString("zcbh");
            zczt = rs.getString("zczt");
            ckmc = rs.getString("ckmc");
            ggxh = rs.getString("ggxh");
            zcmc = rs.getString("zcmc");
            bz = rs.getString("bz");
            Json.put("zcbm",zcbh);
            Json.put("ckmc",ckmc);
            Json.put("zczt",zczt);
            Json.put("ggxh",ggxh);
            Json.put("bgy",bgy);
            Json.put("pm",pm);
            Json.put("zcmc",zcmc);
            Json.put("bz",bz);
            Json.put("kcsl",kcsl);
            Json.put("id",id);
            Json.put("jldw1",jldw1);
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