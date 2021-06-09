<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="org.apache.commons.mail.HtmlEmail" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *    发送面试邮件 zys
     */
    new BaseBean().writeLog("》》》》》》》》开始执行发送邮件");
    RecordSet rs = new RecordSet();//
    User users1 = HrmUserVarify.getUser(request, response);
    RecordSet rs_263 = new RecordSet();//
    RecordSet rs_gw = new RecordSet();//
    JSONObject jsonObject1 = new JSONObject();
    jsonObject1.put("code","203");
    jsonObject1.put("msg","发送失败，接口存在错误！请联系接口开发人员。");
    String lxr = request.getParameter("xm");                             //收件人姓名
    String gw = request.getParameter("ypgw");                                 //岗位
    String recipientemail = request.getParameter("lxyx");          //收件人邮箱
    String xb= request.getParameter("xb");                //性别 1.女，2.男
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date1 = new Date();
    new BaseBean().writeLog("系统当前时间"+df.format(date1));
    String mstime = request.getParameter("rzfzrqrymsj");//面试时间
    String datetime = request.getParameter("rzfzrqrymrq");//面试日期
    String yjzt = "面试通知";//邮件主题
    String year =datetime.substring(0,datetime.indexOf("-"));//年
    String b =datetime.substring(datetime.indexOf("-")+1);
    String mouth=b.substring(0, b.indexOf("-"));//月
    String day = b.substring(b.indexOf("-")+1);//日
    SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
    String[] weekDays = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
    Calendar cal = Calendar.getInstance();
    Date date;
    try {
        date = f.parse(datetime);
        cal.setTime(date);
    } catch (ParseException e) {
        e.printStackTrace();
    }
    //一周的第几天
    int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
    if (w < 0)
        w = 0;
    String weekDays1 =weekDays[w];
    String  sql = "";
    String  sql1 = "";
    if (xb.equals("1")){
        sql = "select * from uf_yjmb where xh=000001";
    }else {
        sql = "select * from uf_yjmb where xh=000002";
    }
    //String sql_ = "select * from cus_fielddata where id=" + users1.getUID();//查询发件人邮件密码
    //rs_.execute(sql_);
    String gw_name ="";
    String sql0 ="SELECT JOBTITLEMARK FROM hrmjobtitles  where id="+gw;
    rs_gw.execute(sql0);
    while (rs_gw.next()){
        gw_name=  rs_gw.getString("JOBTITLEMARK");
    }
    rs.execute(sql);
    HtmlEmail email = new HtmlEmail();
    String  sendEmali = "hqts.it@hqts.com";//发件人邮件
    String field23 = "xiao1713";//发件人邮件密码
    /*while (rs_.next()){
        field23 = rs_.getString("field23");
    }*/
        while(rs.next()) {
            //获取mbnr这列数据
            String mbnr = rs.getString("mbnr");
            String mbnrre = mbnr.replace("￥", "").replace("lxr", lxr).replace("gw", gw_name).replace("<u>&nbsp;&nbsp;&nbsp;&nbsp; </u>年","<u>"+year+"</u>"+"年");
            String ma =mbnrre.replace("<u> &nbsp; &nbsp;</u>月", "<u>"+mouth+"</u>"+"月").replace("<u>&nbsp;&nbsp;&nbsp;&nbsp; </u>日", "<u>"+day+"</u>"+"日");
            String mbn =ma.replace("(<u>&nbsp;&nbsp;&nbsp;&nbsp; </u>）", "(<u>"+weekDays1+"</u>)").replace("<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </u>", "<u>"+mstime+"</u>");

            //输出结果
            new BaseBean().writeLog(mbn);
            // 这里是SMTP发送服务器的名字：263的`："smtp.263.com"
            email.setHostName("smtp.263.net");
            // 字符编码集的设置
            email.setCharset("UTF-8");
            try {
                // 收件人的邮箱
                email.addTo(recipientemail);
                // 发送人的邮箱
                email.setFrom(sendEmali);
                // 如果需要认证信息的话，设置认证：用户名-密码。分别为发件人在邮件服务器上的注册名称和密码
                email.setAuthentication(sendEmali, field23);
                // 要发送的邮件主题
                email.setSubject(yjzt);
                // 要发送的信息，由于使用了HtmlEmail，可以在邮件内容中使用HTML标签
                email.setMsg(mbn);
                // 发送
                email.send();
                int fszt=0;

                sql1 = "Insert into uf_yfsyjjlb (yjzt,fjr,fjrgh,fjryx,sjr,sjryx,fssj,fszt) VALUES ('"+yjzt+"','"+users1.getUID()+"','"+users1.getLoginid()+"','"+sendEmali+"','"+lxr+"','"+recipientemail+"','"+df.format(date1)+"','"+fszt+"')";
                boolean rs2= rs_263.execute(sql1);
                if (rs2){
                    jsonObject1.put("code","200");
                    jsonObject1.put("msg","发送成功,插入数据库成功");
                }else{
                    jsonObject1.put("code","201"+sql1);
                    jsonObject1.put("msg","发送成功，插入数据库失败");
                }

            } catch (Exception e) {
                int fszt=1;//失败
                // TODO: handle exception
                sql1 = "Insert into uf_yfsyjjlb (yjzt,fjr,fjrgh,fjryx,sjr,sjryx,fssj,fszt) VALUES ('"+yjzt+"','"+users1.getUID()+"','"+users1.getLoginid()+"','"+users1.getEmail()+"','"+lxr+"','"+recipientemail+"','"+df.format(date1)+"','"+fszt+"')";
                rs_263.execute(sql1);
                jsonObject1.put("code","202");
                jsonObject1.put("msg","发送失败，接口存在错误！请联系接口开发人员。");
                e.printStackTrace();
            }
        }
                out.clear();
                out.print(jsonObject1);
%>