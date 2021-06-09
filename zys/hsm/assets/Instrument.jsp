<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      仪器盘点接口
     *      zys
     *      20210205
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行仪器盘点接口操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String gzlb = request.getParameter("gzlb");
    String sql="";
    try {
        sql="SELECT * FROM uf_yqbp_dt1 WHERE mainid in"+"("+"SELECT id FROM uf_yqbp WHERE gzlb in "+"("+gzlb+")"+")";//仪器明细
        String yqmc ="";//仪器名称
        String ggxh="";//	规格型号
        String 	yqlc= "";//量程
        String 	yqjd="";//精度
        String 	sl= "";//数量
        new BaseBean().writeLog("当前执行的语句："+sql+",工种类别："+gzlb);
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            yqmc = rs.getString("yqmc");
            ggxh = rs.getString("ggxh");
            yqlc = rs.getString("yqlc");
            sl = rs.getString("sl");
            Json.put("yqmc",yqmc);
            Json.put("ggxh",ggxh);
            Json.put("yqlc",yqlc);

            Json.put("sl",sl);
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