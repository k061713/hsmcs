<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      模块>
     *      仪器档案
     *      时间修改
     *      zys
     *      2021513
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行时间修改操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String ids = request.getParameter("ids");//档案id
    String a[] = ids.split(",");
    String sql="";
    String sql1="";
    try {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date date1 = new Date();

        //Date date2 = df.parse("2020-11-30");

        String bcjyrq =df.format(date1);
        for (int i=0;i<a.length;i++){
            String a1 = a[i];
            String xyzqy="";
            sql = "select * from uf_gdzc where id ="+a1;
            rs.execute(sql);
            while (rs.next()){
                xyzqy =rs.getString("xyzqy");
            }
            if(xyzqy.equals("0")){
                xyzqy="3";
            }else if(xyzqy.equals("1")){
                xyzqy="6";
            }else if(xyzqy.equals("2")){
                xyzqy="12";
            }else if(xyzqy.equals("3")){
                xyzqy="24";
            }
            if(xyzqy.equals("4")){
                String  dqsj="";
                sql1="update uf_gdzc set xcxysj='"+dqsj+"',bcxyrq='"+bcjyrq+"' where id="+a1;
            }else {
                new BaseBean().writeLog(">>>>>>>>>>>>>>xyzqy<<<<<<<<<"+xyzqy);
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(date1);
                calendar.add(Calendar.MONTH, Integer.parseInt(xyzqy));
                Date newDate = calendar.getTime();
                String dqsj =df.format(newDate);
                sql1="update uf_gdzc set xcxysj='"+dqsj+"',bcxyrq='"+bcjyrq+"' where id="+a1;
            }
            new BaseBean().writeLog(">>>>>>>>>>>>>>sql1<<<<<<<<<"+sql1);
            rs1.execute(sql1);
        }
        json.put("code", "200");
        json.put("msg", "更新成功");

    } catch (Exception e) {
        json.put("code", "202");
        json.put("msg", "更新失败，系统接口出错！");
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>