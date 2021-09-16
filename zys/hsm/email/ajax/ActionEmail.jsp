<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.apache.commons.mail.HtmlEmail" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="javax.mail.BodyPart" %>
<%@ page import="javax.mail.internet.MimeBodyPart" %>
<%@ page import="javax.activation.DataSource" %>
<%@ page import="javax.activation.FileDataSource" %>
<%@ page import="javax.activation.DataHandler" %>
<%@ page import="javax.mail.internet.MimeUtility" %>
<%@ page import="javax.mail.Multipart" %>
<%@ page import="javax.mail.internet.MimeMultipart" %>
<%@ page import="org.apache.commons.mail.EmailAttachment" %>
<%@ page import="weaver.file.ImageFileManager" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.ZipFile" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="java.util.zip.ZipEntry" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *    发送行动计划邮件 zys
     */
    new BaseBean().writeLog("》》》》》》》》开始执行发送邮件");
    RecordSet rs = new RecordSet();//
    RecordSet rs_ = new RecordSet();//
    RecordSet rs_1 = new RecordSet();//
    RecordSet rs_2 = new RecordSet();//
    int buffersize = 1024;
    int count = 0;
    byte[] buffer = new byte[buffersize];
    User users1 = HrmUserVarify.getUser(request, response);
    JSONObject jsonObject1 = new JSONObject();
    jsonObject1.put("code","203");
    jsonObject1.put("msg","发送失败，接口存在错误！请联系接口开发人员。");
    //String lxr_xiansuo = request.getParameter("lxr_xiansuo");   //联络人
    String lyx = request.getParameter("lyx");                   //收件人邮箱
    String sqrjsdzyx = request.getParameter("sqrjsdzyx");      //申请人角色电子邮箱
    String lnrxs = request.getParameter("lnrxs");              //联络内容（销售）
    String lztxs = request.getParameter("lztxs");              //联络主题（销售）
    String lfjxs = request.getParameter("lfjxs");//联络附件（销售）
    Map<String, Object> map = new HashMap<String, Object>();
    File file = null;
    EmailAttachment attachment = null;
    HtmlEmail email = new HtmlEmail();
    String sql_ = "select dzyxmm from uf_ryda where gh=" + users1.getLoginid();//查询发件人邮件密码
    new BaseBean().writeLog("执行5："+sql_);
    boolean b =rs_.execute(sql_);
    if(b){
        while (rs_.next()){
            String sql_1="";
            String field72 = rs_.getString("dzyxmm");//申请人/发件人邮件密码
            new BaseBean().writeLog("密码："+field72);
            if(!lfjxs.equals("")){//判断是否存在附件
                sql_1 = "select IMAGEFILEID from docimagefile where docid in("+lfjxs+")" ;
                rs_1.execute(sql_1);
                while (rs_1.next()){
                    String sql_2 = "select IMAGEFILENAME,FILEREALPATH from imagefile where IMAGEFILEID ="+rs_1.getString("IMAGEFILEID");
                    new BaseBean().writeLog("执行2"+sql_2);
                    rs_2.execute(sql_2);
                    InputStream in1 = null;
                    OutputStream out1 =null;
                    String newFilePath = null;
                    while (rs_2.next()){
                        String filename = rs_2.getString("IMAGEFILENAME");
                        String str1 =filename.substring(0,filename.indexOf("."));
                        str1 = str1.trim();
                        if ("".equals(str1) || str1 == null) // 文件名不能为空
                            return;

                        String filepath = rs_2.getString("FILEREALPATH");
                        File f = new File(filepath);
                        if (f.isDirectory()) { // 判断是否为文件夹
                            newFilePath = filepath.substring(0, filepath.lastIndexOf("\\")) ;
                        } else {
                            newFilePath = filepath.substring(0, filepath.lastIndexOf("\\")) +"\\" + str1+ filepath.substring(filepath.lastIndexOf("."));
                        }

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
                                System.out.println("isDirectory");
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
                            //new BaseBean().writeLog("文件名："+filename);
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
            }
            // 这里是SMTP发送服务器的名字：263的`："smtp.263.com"，qq的："smtp.qq.com"
            //new BaseBean().writeLog("执行5"+attachment);
            String regex = "[1-9][0-9]{8,10}\\@[q][q]\\.[c][o][m]";
            if(sqrjsdzyx.matches(regex)){
                email.setHostName("smtp.qq.com");
            }else{
                email.setHostName("smtp.263.net");
            }

            // 字符编码集的设置
            email.setCharset("UTF-8");
            try {

                // 收件人的邮箱
                email.addTo(lyx);

                // 发送人的邮箱
                email.setFrom(sqrjsdzyx);

                // 如果需要认证信息的话，设置认证：用户名-密码。分别为发件人在邮件服务器上的注册名称和密码
                email.setAuthentication(sqrjsdzyx, field72);

                // 要发送的邮件主题
                email.setSubject(lztxs);
                // 要发送的信息，由于使用了HtmlEmail，可以在邮件内容中使用HTML标签
                email.setMsg(lnrxs);
                new BaseBean().writeLog(">>>>>>>>>>>>>>>>>>>>>执行6："+lyx+","+sqrjsdzyx+","+field72+","+lztxs);
                // email.attach(affix);
                // 发送
                email.send();
                new BaseBean().writeLog("执行6："+"发送成功");
                jsonObject1.put("code","200");
                jsonObject1.put("msg","发送成功。");
            } catch (Exception e) {
                jsonObject1.put("code","202");
                jsonObject1.put("msg","发送失败，接口存在错误！请联系接口开发人员。");
                e.printStackTrace();
            }
        }
    }else{
        jsonObject1.put("code","203");
        jsonObject1.put("msg","发送失败，发送邮箱密码错误！");
    }
    out.clear();
    out.print(jsonObject1);
%>