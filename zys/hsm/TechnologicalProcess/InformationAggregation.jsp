<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *
     *      验货员信息汇总
     *      统计天数
     *      zys
     *      2021513
     */
    new BaseBean().writeLog(">>>>>开始执行验货员信息汇总<<<<<");
    
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    List<String> list = new ArrayList<>();
    List<String> list1 = new ArrayList<>();
    Map<String,Integer> map = new HashMap<>();
    Map<String,Integer> map1 = new HashMap<>();
    String mx1=request.getParameter("mx1");
    String mx2=request.getParameter("mx2");
    String sb=request.getParameter("yhy");
    new BaseBean().writeLog("数据："+sb);
    String sql="";
    String sql1="";
    String sbz[] =sb.split("~");
    String b= sbz[0];
    String b1= sbz[1];
    String[] b_1= b.split(",");
    String[] b1_1= b1.split(",");
    for(int i=0;i<b_1.length;i++) {
        String b_11=b_1[i];
        list.add(b_11);
    }
    System.out.println(list);
    for(String str:list){
        Integer i = 1; //定义一个计数器，用来记录重复数据的个数
        if(map.get(str) != null){
            i=map.get(str)+1;
        }
        map.put(str,i);
    }
    //System.out.println("id:"+str+",数量："+i);
    new BaseBean().writeLog("重复数据的个数："+map.toString());
    for (Map.Entry<String, Integer> entry : map.entrySet()) {
        new BaseBean().writeLog("key = " + entry.getKey() + ", value = " + entry.getValue());
        sql="insert into "+mx2+" (yhy,yhyxz,ts) value (("+entry.getKey()+"),"+0+","+entry.getValue()+")";
        rs.execute(sql);
    }
    for(int j=0;j<b1_1.length;j++) {
        String bj_11=b1_1[j];
        list1.add(bj_11);
    }
    for(String str1:list1){
        Integer i1 = 1; //定义一个计数器，用来记录重复数据的个数
        if(map1.get(str1) != null){
            i1=map1.get(str1)+1;
        }
        map1.put(str1,i1);
    }
    new BaseBean().writeLog("重复数据的个数1："+map1.toString());
    for (Map.Entry<String, Integer> entry1 : map1.entrySet()) {
        new BaseBean().writeLog("key = " + entry1.getKey() + ", value = " + entry1.getValue());
        sql1="insert into "+mx2+" (yhy,yhyxz,ts) value (("+entry1.getKey()+"),"+1+","+entry1.getValue()+")";
        rs1.execute(sql1);
    }
%>

<%--
SELECT
    id,SUBSTRING_INDEX(SUBSTRING_INDEX(a.jyzy,',',help_topic_id+1),',',-1) AS jyzy,COUNT(jyzy)
FROM
    mysql.help_topic m, formtable_main_392_dt2 a
WHERE
    help_topic_id < LENGTH(a.jyzy)-LENGTH(REPLACE(a.jyzy,',',''))+1 GROUP BY jyzy

SELECT  jyzc,COUNT(jyzc) num from formtable_main_392_dt2 GROUP BY jyzc ORDER BY num
    --%>