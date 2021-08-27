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
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="org.apache.commons.mail.EmailAttachment" %>
<%@ page import="javax.mail.internet.MimeUtility" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *     市场管理接口
     *      SC12 推广邮件
     *      zys
     *      20210526
     */

    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行推广邮件操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    RecordSet rs4 = new RecordSet();
    RecordSet rs5 = new RecordSet();
    RecordSet rs6 = new RecordSet();
    AtomicInteger atomicNum = new AtomicInteger();
    //String workflowid = request.getParameter("workflowid");
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
    String rymc =(request.getParameter("rymc").equals("")) ?null:request.getParameter("rymc");//	人员名称
    String fsyjzt= (request.getParameter("fsyjzt").equals(""))?null:request.getParameter("fsyjzt");//邮件主题
    String fsnr= (request.getParameter("fsnr").equals(""))?null:request.getParameter("fsnr");//邮件内容
    String fsyjfj= (request.getParameter("fsyjfj").equals(""))?null:request.getParameter("fsyjfj");//附件
    String yjfsplm=request.getParameter("yjfsplm");//发送频率
    String fssj=request.getParameter("fssj");//发送时间
    String fsrqjs=request.getParameter("fsrqjs");//结束时间
    String khsl=request.getParameter("khsl");//客户数量
    String ygsl=request.getParameter("yjfsygsl");//员工数量
    String fsdx=request.getParameter("fsdx");//发送对象
    String yjmbmc=request.getParameter("yjmbmc");//邮件模板名称id
    String sql="";
    String sql1="";
    String sql2="";
    String sql3="";
    String sql4="";
    String sql5="";
    String sql6="";
    String lsh="";
    String mbnr="";
    String newStrNum="";
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
    Date date1 = new Date();
    try {

        sql6="select * from uf_yjmb where id="+yjmbmc;
        rs6.execute(sql6);
        while (rs6.next()){
            mbnr = rs6.getString("mbnr");
        }
        String[] fsdx1 = fsdx.split(",");
        for (int i= 0;i<fsdx1.length;i++){
            String fsdx2= fsdx1[i].toString();
            if (fsdx2.equals("0")){
                if(ygsl!=""){
                    sql5= "insert into formtable_main_804 (yjfsygsl) value ("+ygsl+")";
                    rs5.execute(sql5);
                }
                if(rymc!=null){
                    sql2 = "select * from uf_ryda where rymc in("+rymc+")";
                    rs2.execute(sql2);
                    while (rs2.next()){
                        //线程安全的原子操作，所以此方法无需同步
                        int newNum = atomicNum.incrementAndGet();
                        //数字长度为5位，长度不够数字前面补0
                        newStrNum = String.format("%05d", newNum);//5位流水号
                        lsh= df.format(date1)+newStrNum;
                        new BaseBean().writeLog("流水号："+lsh);
                        String jsdzyx = rs2.getString("jsdzyx");
                        String ryid= rs2.getString("rymc");//联系人id
                        juse(jsdzyx,fsyjfj,ryid,lsh,fsyjzt,mbnr,yjfsplm,fssj,fsrqjs);
                        //Thread.sleep(3000);
                    }
                }
            }else {
                String[] khfwjd1 = khfwjd.split(",");
                for (int j= 0;j<khfwjd1.length;j++){//服务阶段
                    String khfwjd2= khfwjd1[j].toString();
                    new BaseBean().writeLog("khfwjd2："+khfwjd2);
                    if (khfwjd2.equals("10")){//线索
                        new BaseBean().writeLog("fstjgx："+fstjgx);
                        if(fstjgx.equals("0")){//发送条件关系or
                            sql="select * from uf_xsk where ywgsjg in("+khywgzjg+") or gj in("+ gj+") or sf in("+sf+") or cs in("+cs+") or hydl in("+hydl+") or hyzl in("+hyzl+") or hyxl in("+hyxl+") or fwdl in("+fwdl+") or fwzl in("+fwzl+") or plgz in("+plgz+") or cjrssjg in("+cjrssjg+") or cjrssbm in("+cjrssbm+") or gsgm in("+gsgm+")";
                        }else {//发送条件关系and
                            sql="select * from uf_xsk where ywgsjg in("+khywgzjg+") and gj in("+ gj+") and sf in("+sf+") and cs in("+cs+") and hydl in("+hydl+") and hyzl in("+hyzl+") and hyxl in("+hyxl+") and fwdl in("+fwdl+") and fwzl in("+fwzl+") and plgz in("+plgz+") and cjrssjg in("+cjrssjg+") and cjrssbm in("+cjrssbm+") and gsgm in("+gsgm+")";
                        }
                    }else {//非线索
                        if(fstjgx.equals("0")){
                            sql="select * from uf_khgl where ywgsjg in("+khywgzjg+") or gj in("+ gj+") or sf in("+sf+") or cs in("+cs+") or hydl in("+hydl+") or hyzl in("+hyzl+") or hyxl in("+hyxl+") or fwdl in("+fwdl+") or fwzl in("+fwzl+") or fwxl in("+fwxl+") or plgz in("+plgz+") or cjrssjg in("+cjrssjg+") or cjrssbm in("+cjrssbm+") or gsgm in("+gsgm+")";
                        }else {
                            sql="select * from uf_khgl where ywgsjg in("+khywgzjg+") and gj in("+ gj+") and sf in("+sf+") and cs in("+cs+") and hydl in("+hydl+") and hyzl in("+hyzl+") and hyxl in("+hyxl+") and fwdl in("+fwdl+") and fwzl in("+fwzl+") and fwxl in("+fwxl+") and plgz in("+plgz+") and cjrssjg in("+cjrssjg+") and cjrssbm in("+cjrssbm+") and gsgm in("+gsgm+")";
                        }
                    }
                    new BaseBean().writeLog("sql："+sql);
                    rs.execute(sql);

                    while (rs.next()){
                        String khqcid =rs.getString("id");
                        String ryid = "";
                        String jsdzyx="";
                        sql1 ="select * from uf_xsk_dt1 where mainid= "+khqcid+" and fstgyj=0";//线索明细1

                        new BaseBean().writeLog("sql1："+sql1);
                        rs1.execute(sql1);
                        while (rs1.next()){
                            //线程安全的原子操作，所以此方法无需同步
                            int newNum = atomicNum.incrementAndGet();
                            //数字长度为5位，长度不够数字前面补0
                            newStrNum = String.format("%05d", newNum);//5位流水号
                            lsh= df.format(date1)+newStrNum;
                            new BaseBean().writeLog("流水号："+lsh);
                            //循环获取邮箱
                            jsdzyx= rs1.getString("yx");//联系人邮箱
                            //String jsdzyx= "653907662@qq.com";//联系人邮箱
                            ryid= rs1.getString("id");//联系人id
                            juse(jsdzyx,fsyjfj,ryid,lsh,fsyjzt,mbnr,yjfsplm,fssj,fsrqjs);
                            //Thread.sleep(3000);
                        }
                    }
                    if(khsl!=""){
                        sql4= "insert into formtable_main_804 (yjfsygsl) value ("+khsl+")";
                        rs4.execute(sql4);
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
%>
<%!
    public void juse(String jsdzyx,String fsyjfj,String ryid,String lsh,String fsyjzt,String mbnr,String yjfsplm,String fssj,String fsrqjs){
        JSONObject jsonObject1 = new JSONObject();
        RecordSet rs = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        String sql="";
        String sql1="";
        String sql2="";
        String emailZh="hqtsgroup@hqts.com";
        String emailMm="HQTS@20215";
        String filepath="";
        InputStream in1 = null;
        OutputStream out1 =null;
        String newFilePath = null;
        EmailAttachment attachment = null;
        HtmlEmail email = new HtmlEmail();
        String IMAGEFILEID = "";//图片文件id
        String filename="";
        new BaseBean().writeLog("模板源码："+mbnr);
        try {
            sql ="select * from docimagefile where docid in("+fsyjfj+")";
            if (jsdzyx != null && jsdzyx != "") {
                new BaseBean().writeLog("jsdzyx："+jsdzyx);
                rs.execute(sql);
                while (rs.next()){
                    new BaseBean().writeLog("1："+sql);
                    IMAGEFILEID = rs.getString("IMAGEFILEID");//图片文件id
                    new BaseBean().writeLog("IMAGEFILEID："+IMAGEFILEID);
                    filename =rs.getString("IMAGEFILENAME");//附件名称
                    new BaseBean().writeLog("filename："+filename);
                    sql1 ="select * from imagefile where IMAGEFILEID ="+IMAGEFILEID;
                    new BaseBean().writeLog("sql1："+sql1);
                    rs1.execute(sql1);
                    while (rs1.next()){
                        filepath= rs1.getString("FILEREALPATH");//附件地址
                        new BaseBean().writeLog("filepath："+filepath);

                        String str1 = filename.trim();
                        if ("".equals(str1) || str1 == null) // 文件名不能为空
                            return;
                        File f = new File(filepath);
                        if (f.isDirectory()) { // 判断是否为文件夹
                            newFilePath = filepath.substring(0, filepath.lastIndexOf("\\")) ;
                        } else {
                            newFilePath = filepath.substring(0, filepath.lastIndexOf("\\")) +"\\" + str1;
                        }
                        new BaseBean().writeLog("newFilePath："+newFilePath);
                        File nf = new File(newFilePath);
                        //f.renameTo(nf);

                        ZipFile zipFile=new ZipFile(new File(filepath), Charset.forName("gbk"));

                        String filePath1 =null;
                        new BaseBean().writeLog("执行3"+filepath);
                        for (Enumeration zipEntries = zipFile.entries(); zipEntries.hasMoreElements();) {//遍历压缩文件中所有的子文bai件
                            ZipEntry entry = ((ZipEntry) zipEntries.nextElement());//获取子文件的名字
                            in1 = zipFile.getInputStream(entry);
                            filePath1 = filepath.substring(0, filepath.lastIndexOf("\\")) + "\\" + filename;
                            File file1 = new File(filePath1.substring(0, filePath1.lastIndexOf("\\")));
                            if (!file1.exists()) {
                                file1.mkdirs();
                            }
                            if (entry.isDirectory()) {
                                //System.out.println("isDirectory");
                                File path = new File(filePath1);
                                if (!path.exists()) {
                                    path.mkdir();
                                }
                                continue;
                            }
                            out1 = new FileOutputStream(filePath1);

                            byte[] buf1 = new byte[1024];
                            int len;
                            while ((len = in1.read(buf1)) > 0) {
                                out1.write(buf1, 0, len);
                            }
                            //new BaseBean().writeLog("文件名："+fsyjfj);
                            in1.close();
                            out1.close();
                        }
                        attachment = new EmailAttachment();
                        attachment.setPath(filePath1);
                        attachment.setName(MimeUtility.encodeText(filename));
                        new BaseBean().writeLog("执行str4:"+filePath1);
                        email.attach(attachment);
                    }
                }
                email.setHostName("smtp.263.net");
                email.setCharset("UTF-8");
               // email.setContent(content, "text/html");
                try {

                    // 收件人的邮箱
                    email.addTo(jsdzyx);

                    // 发送人的邮箱
                    email.setFrom(emailZh);

                    // 如果需要认证信息的话，设置认证：用户名-密码。分别为发件人在邮件服务器上的注册名称和密码
                    email.setAuthentication(emailZh, emailMm);

                    // 要发送的邮件主题
                    email.setSubject(fsyjzt);
                    // 要发送的信息，由于使用了HtmlEmail，可以在邮件内容中使用HTML标签
                   // email.setMsg(fsnr);
                    email.setContent(mbnr, "text/html");
                    new BaseBean().writeLog(">>>>>>>>>>>>>>>>>>>>>执行6：" + jsdzyx + "," + emailZh + "," + emailMm + "," + fsyjzt);
                    // email.attach(affix);
                    // 发送
                    email.send();
                    new BaseBean().writeLog("执行6：" + "发送成功");
                    sql2 = "insert into uf_yfstgyjjlb (xh,nbyg,nbygyx,yjzt,jhksfsrq,jhjsfsrq,yjfsplm,yjsfck,fszt) value (" + lsh + "," + ryid + ",'" + jsdzyx + "','" + fsyjzt + "','" + fssj + "','" + fsrqjs + "','" + yjfsplm + "'," + 1 + "," + 0 + ")";
                    rs2.execute(sql2);
                    jsonObject1.put("code", "200");
                    jsonObject1.put("msg", "发送成功。");
                } catch (Exception e) {

                    sql2 = "insert into uf_yfstgyjjlb (xh,nbyg,nbygyx,yjzt,jhksfsrq,jhjsfsrq,yjfsplm,yjsfck,fszt) value (" + lsh + "," + ryid + ",'" + jsdzyx + "','" + fsyjzt + "','" + fssj + "','" + fsrqjs + "','" + yjfsplm + "'," + 1 + "," + 1 + ")";
                    rs2.execute(sql2);
                    jsonObject1.put("code", "202");
                    jsonObject1.put("msg", "发送失败，接口存在错误！请联系接口开发人员。");
                    e.printStackTrace();
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }

    }
%>