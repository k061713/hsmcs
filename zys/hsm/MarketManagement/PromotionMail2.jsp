<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.mail.HtmlEmail" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.atomic.AtomicInteger" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="org.apache.commons.mail.EmailAttachment" %>
<%@ page import="javax.mail.internet.MimeUtility" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *     市场管理接口
     *      SC12 推广邮件/联系人数量
     *      zys
     *      20210526
     */

    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行推广邮件/联系人数量就算操作<<<<<<<<<");
    RecordSet rs1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    RecordSet rs4 = new RecordSet();
    JSONObject json = new JSONObject();
    AtomicInteger atomicNum = new AtomicInteger();
    String fstjgx = request.getParameter("fstjgx");//	发送条件关系
    String khfwjd = (request.getParameter("khfwjd").equals(""))?null:request.getParameter("khfwjd");//	客户服务阶段
    String khywgzjg = (request.getParameter("khywgzjg").equals(""))?null:request.getParameter("khywgzjg");//	客户业务归属机构
    String gj = (request.getParameter("gj").equals(""))?null:request.getParameter("gj");//	国家地区
    String sf = (request.getParameter("sf").equals(""))?null:request.getParameter("sf");//	省份
    String cs = (request.getParameter("cs").equals(""))?null:request.getParameter("cs");//	城市
    String hydl = (request.getParameter("hydl").equals(""))?null:request.getParameter("hydl");//	行业大类
    String hyzl = (request.getParameter("hyzl").equals(""))?null:request.getParameter("hyzl");//	行业中类
    String hyxl = (request.getParameter("hyxl").equals(""))?null:request.getParameter("hyxl");//	行业小类
    String fwdl =(request.getParameter("fwdl").equals(""))?null:request.getParameter("fwdl");//	服务大类
    String fwzl = (request.getParameter("fwzl").equals(""))?null:request.getParameter("fwzl");//	服务中类
    String fwxl = (request.getParameter("fwxl").equals(""))?null:request.getParameter("fwxl");//	服务小类
    String plgz = (request.getParameter("plgz").equals(""))?null:request.getParameter("plgz");//	客户品类归属
    String cjrssjg = (request.getParameter("khcjrszjg").equals(""))?null:request.getParameter("khcjrszjg");//	创建人所属机构
    String cjrssbm = (request.getParameter("khcjrszbm").equals(""))?null:request.getParameter("khcjrszbm");//	创建人所属部门
    String gsgm = (request.getParameter("khgsgm").equals(""))?null:request.getParameter("khgsgm");//	公司规模

    int lxrzsl=0;
    List<String> khidz = new ArrayList<String>();
    String sql1="";
    String sql2="";
    String sql3="";
    String sql4="";
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
    Date date1 = new Date();
    //线程安全的原子操作，所以此方法无需同步
    int newNum = atomicNum.incrementAndGet();
    //数字长度为5位，长度不够数字前面补0
    String newStrNum = String.format("%05d", newNum);//5位流水号
    String lsh= df.format(date1)+newStrNum;
    new BaseBean().writeLog("流水号："+lsh);
    try {
        String[] khfwjd1 = khfwjd.split(",");
        int xslxrsl=0;
        int khlxrsl=0;
        for (int i= 0;i<khfwjd1.length;i++){//服务阶段

            List<String> khid = new ArrayList<String>();

            String khfwjd2= khfwjd1[i].toString();
            new BaseBean().writeLog("khfwjd2："+khfwjd2);
            if (khfwjd2.equals("10")){
                new BaseBean().writeLog("fstjgx："+fstjgx);
                if(fstjgx.equals("0")){
                    sql3="select * from uf_xsk where ywgsjg in("+khywgzjg+") or gj in("+ gj+") or sf in("+sf+") or cs in("+cs+") or hydl in("+hydl+") or hyzl in("+hyzl+") or hyxl in("+hyxl+") or fwdl in("+fwdl+") or fwzl in("+fwzl+") or plgz in("+plgz+") or cjrssjg in("+cjrssjg+") or cjrssbm in("+cjrssbm+") or gsgm in("+gsgm+")";
                }else {
                    sql3="select * from uf_xsk where ywgsjg in("+khywgzjg+") and gj in("+ gj+") and sf in("+sf+") and cs in("+cs+") and hydl in("+hydl+") and hyzl in("+hyzl+") and hyxl in("+hyxl+") and fwdl in("+fwdl+") and fwzl in("+fwzl+") and plgz in("+plgz+") and cjrssjg in("+cjrssjg+") and cjrssbm in("+cjrssbm+") and gsgm in("+gsgm+")";
                }
                new BaseBean().writeLog("sql3："+sql3);
                rs3.execute(sql3);
                while (rs3.next()){
                    String khqcid =rs3.getString("id");
                    sql1 ="select * from uf_xsk_dt1 where mainid= "+khqcid+" and fstgyj=0";//线索明细1

                    new BaseBean().writeLog("sql1："+sql1);
                    rs1.execute(sql1);
                    while (rs1.next()){
                        khid.add(rs1.getString("id"));
                    }
                    sql4="select count(*) as lxrsl from uf_xsk_dt1 where mainid= "+khqcid+" and fstgyj=0" ;//线索下的联系人数量（发送推广邮件状态为：是）
                    //  new BaseBean().writeLog("sql4："+sql4);
                    rs4.execute(sql4);

                    while (rs4.next()){
                        int xslxrsl1 = Integer.valueOf(rs4.getString("lxrsl"));
                        xslxrsl+=xslxrsl1;
                    }

                }

            }else {
                if(fstjgx.equals("0")){
                    sql3="select * from uf_khgl where ywgsjg in("+khywgzjg+") or gj in("+ gj+") or sf in("+sf+") or cs in("+cs+") or hydl in("+hydl+") or hyzl in("+hyzl+") or hyxl in("+hyxl+") or fwdl in("+fwdl+") or fwzl in("+fwzl+") or fwxl in("+fwxl+") or plgz in("+plgz+") or cjrssjg in("+cjrssjg+") or cjrssbm in("+cjrssbm+") or gsgm in("+gsgm+")";
                }else {
                    sql3="select * from uf_khgl where ywgsjg in("+khywgzjg+") and gj in("+ gj+") and sf in("+sf+") and cs in("+cs+") and hydl in("+hydl+") and hyzl in("+hyzl+") and hyxl in("+hyxl+") and fwdl in("+fwdl+") and fwzl in("+fwzl+") and fwxl in("+fwxl+") and plgz in("+plgz+") and cjrssjg in("+cjrssjg+") and cjrssbm in("+cjrssbm+") and gsgm in("+gsgm+")";
                }
                new BaseBean().writeLog("sql3："+sql3);
                rs3.execute(sql3);
                while (rs3.next()){
                    String khqcid =rs3.getString("id");
                    sql1 ="select * from uf_khgl_dt1 where mainid= "+khqcid+" and fstgyj=0";//客户明细1

                    new BaseBean().writeLog("sql1："+sql1);
                    rs1.execute(sql1);
                    while (rs1.next()){
                        khid.add(rs1.getString("id"));
                    }
                    sql4="select count(*) as lxrsl from uf_khgl_dt1 where mainid= "+khqcid+" and fstgyj=0" ;//客户下的联系人数量（发送推广邮件状态为：是）
                    //  new BaseBean().writeLog("sql4："+sql4);
                    rs4.execute(sql4);
                    while (rs4.next()){
                        int khlxrsl1 = Integer.valueOf(rs4.getString("lxrsl"));
                        khlxrsl+=khlxrsl1;
                    }
                }
            }
            khidz.addAll(khid);
            lxrzsl=khlxrsl+xslxrsl;
        }


        new BaseBean().writeLog("lxrsl："+lxrzsl);
        new BaseBean().writeLog("lxrid："+khidz.toString());
        json.put("lxrzsl", lxrzsl);
        json.put("lxrid",khidz.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>
