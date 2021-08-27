<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      质控管理接口
     *      ZK17检验报告申请
     *      分值增减
     *      zys
     *      20210520
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行检验报告申请操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    RecordSet rs4 = new RecordSet();
    RecordSet rs5 = new RecordSet();
    RecordSet rs6 = new RecordSet();
    RecordSet rs7 = new RecordSet();
    RecordSet rs8 = new RecordSet();
    RecordSet rs9 = new RecordSet();
    RecordSet rs10 = new RecordSet();
    RecordSet rs11 = new RecordSet();
    RecordSet rs4_2 = new RecordSet();
    RecordSet rs5_2 = new RecordSet();
    RecordSet rs11_2 = new RecordSet();
    RecordSet rs12 = new RecordSet();
    RecordSet rs12_1 = new RecordSet();
    RecordSet rs13 = new RecordSet();
    RecordSet rs13_1 = new RecordSet();
    RecordSet rs14 = new RecordSet();
    RecordSet rs14_1 = new RecordSet();
    RecordSet rs15 = new RecordSet();
    String khqc = request.getParameter("khqc");//客户全称
    String fwdl = request.getParameter("fwdl");//服务大类
    String fwzl = request.getParameter("fwzl");//服务中类
    String fwxl = request.getParameter("fwxl");//服务小类
    String cpdl = request.getParameter("cpdl");//产品大类
    String cpzl = request.getParameter("cpzl");//产品中类
    String cpxl = request.getParameter("cpxl");//产品小类
    String yhy11 = request.getParameter("yhy");//验货员
    String yhy1[] = yhy11.split("~");
    new BaseBean().writeLog(">>>>>>>>>>>>>>验货员1<<<<<<<<<"+yhy11);
    int bgzdf = Integer.valueOf(request.getParameter("bgzdf"));//报告总得分
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    JSONArray jsonArray1 = new JSONArray();
    String sql="";
    String sql1="";
    String sql2="";
    String sql3="";
    String sql4="";
    String sql5="";
    String sql6="";
    String sql7="";
    String sql8="";
    String sql9="";
    String sql10="";
    String sql11="";
    String sql12="";
    String sql13="";
    String sql14="";
    String sql15="";
    String id="";
    String fzgzlx ="";
    String sfzdrdx= "";
    String sfzdrdz= "";
    try {

        new BaseBean().writeLog(">>>>>>>>>>>>>>次数<<<<<<<<<"+yhy1.length);
        for (int i=0;i<yhy1.length;i++){
            String yhy_1 = yhy1[i].toString();
            String yhy_2[]=yhy_1.split(",");
            String yhyxz= yhy_2[0].toString();
            String yhy =yhy_2[1].toString();
            //new BaseBean().writeLog(">>>>>>>>>>>>>>验货员性质<<<<<<<<<"+yhyxz+",验货员："+yhy);
            //new BaseBean().writeLog(">>>>>>>>>>>>>>验货员性质<<<<<<<<<"+yhyxz);
            sql14 ="select * from uf_fwxl where id="+fwxl;
            rs14.execute(sql14);
            while (rs14.next()){
                sfzdrdx=rs14.getString("sfzdrd");//是否自动认定(服务小类)
            }
            sql15 ="select * from uf_cpdl where id="+cpzl;
            rs15.execute(sql15);
            while (rs15.next()){
                sfzdrdz=rs15.getString("sfzdrd");//是否自动认定（产品中类）
            }
            if(yhyxz.equals("0")){//验货员性质”为“组长”，则这“验货员”为组长
                //验货员为组长
                sql3="select * from uf_ryda where rymc="+yhy;//人员能力表中人员对应的id（对应人员能力表明细2中的mainid）
                rs3.execute(sql3);
                new BaseBean().writeLog(">>>>>>>>>>>>>>“验货员”为组长<<<<<<<<<"+sql3);
                while (rs3.next()){
                    id= rs3.getString("id");
                    sql4="select * from uf_ryda_dt2 where mainid="+id+" and fwxl="+fwxl;//人员能力表“明细表2，uf_ryda_dt2中的服务小类下对应组长的信息
                    rs4.execute(sql4);
                    boolean rs4_1= rs4.next();
                    new BaseBean().writeLog(">>>>>>>>>>>>>>服务小类<<<<<<<<<"+rs4_1);

                    if (!rs4_1){//若“人员能力表”中“明细表2”没有该类的产品能力数据时，直接增加数据
                        new BaseBean().writeLog(">>>>若“人员能力表”中“明细表2”没有该类的产品能力数据时，直接增加数据<<<<<");
                        sql6 = "insert into uf_ryda_dt2 (mainid,fwdl,fwzl,fwxl,sfdl,sfzdrd,dlnlfz,ljnlfz,ljyhzccs,dlhzccs) values ("+id+",'"+fwdl+"','"+fwzl+"','"+fwxl+"',"+1+","+sfzdrdx+",'"+0+"','"+0+"','"+0+"','"+0+"')";
                        rs6.execute(sql6);
                    }
                    sql5="select * from uf_ryda_dt1 where mainid="+id+" and cpzl="+cpzl;//人员能力表“明细表1，uf_ryda_dt1中的产品中类下对应组长的信息
                    //产品中类
                    new BaseBean().writeLog(">>>>>>>>>>>>>>产品中类<<<<<<<<<");
                    rs5.execute(sql5);
                    boolean rs5_1= rs5.next();
                    if (!rs5_1){//若“人员能力表”中“明细表1”没有该类的产品能力数据时，直接增加数据
                        sql7 = "insert into uf_ryda_dt1 (mainid,cpdl,cpzl,sfdl,sfzdrd,dlnlfz,ljnlfz,ljyhzccs,dlhzccs) values ("+id+",'"+cpdl+"','"+cpzl+"',"+1+","+sfzdrdz+",'"+0+"','"+0+"','"+0+"','"+0+"')";
                        rs7.execute(sql7);
                    }
                    rs4_2.execute(sql4);//新增之后在查询//服务小类
                    new BaseBean().writeLog(">>>>>>>>>>>>>>“sql4:<<<<<<<<<"+sql4);
                    while (rs4_2.next()){
                        String sfdl =rs4_2.getString("sfdl");//是否独立
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“sfdl:<<<<<<<<<"+sfdl);
                        String a11 =rs4_2.getString("dlnlfz");
                        if (a11.equals("")){
                            a11="0";
                        }
                        int dlnlfz = Integer.valueOf(a11);
                        //int dlnlfz =Integer.valueOf(rs4_2.getString("dlnlfz")==null?"0":rs4_2.getString("dlnlfz"));//独立能力分值
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“dlnlfz:<<<<<<<<<"+dlnlfz);
                        String a12 =rs4_2.getString("ljnlfz");
                        if (a12.equals("")){
                            a12="0";
                        }
                        int ljnlfz = Integer.valueOf(a12);
                        //int ljnlfz = Integer.valueOf(rs4_2.getString("ljnlfz")==null?"0":rs4_2.getString("ljnlfz"));//累计能力分值
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“ljnlfz:<<<<<<<<<"+ljnlfz);
                        String a13 =rs4_2.getString("ljyhzccs");
                        if (a13.equals("")){
                            a13="0";
                        }
                        int ljyhzccs = Integer.valueOf(a13);
                        //int ljyhzccs =Integer.valueOf(rs4_2.getString("ljyhzycs")==null?"0":rs4_2.getString("ljyhzycs"));//累计验货组长次数
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“ljyhzccs:<<<<<<<<<"+ljyhzccs);
                        String a14 =rs4_2.getString("dlhzccs");
                        if (a14.equals("")){
                            a14="0";
                        }
                        int dlhzccs = Integer.valueOf(a14);
                        //int dlhzccs =Integer.valueOf(rs4_2.getString("dlhzccs")==null?"0":rs4_2.getString("dlhzccs"));//独立后组长次数
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“dlhzccs:<<<<<<<<<"+dlhzccs);
                        sql= "select * from uf_rynlfzgzb where ysfdl ="+sfdl;//人员能力分值规则表信息
                        rs.execute(sql);
                        while (rs.next()) {
                            String sb  = rs.getString("bgzlfsd");
                            if(sb.equals("")) {
                                new BaseBean().writeLog("空");
                                continue ;
                            }
                            BigDecimal a = new BigDecimal(rs.getString("bgzlfsd"));

                            int bgzlfsd = a.intValue();//报告质量分数（大）

                            BigDecimal a1 = new BigDecimal(rs.getString("bgzlfsx"));
                            int bgzlfsx = a1.intValue();//报告质量分数（小）
                            fzgzlx = rs.getString("fzgzlx");//分值规则类型
                            //客户全称
                            new BaseBean().writeLog(">客户全称规则类型<"+fzgzlx);
                            if(fzgzlx.equals("0")){
                                sql11="select * from uf_ryda_dt4 where mainid="+id+" and khqc="+khqc;
                                new BaseBean().writeLog(">客户全称<"+sql11);
                                rs11.execute(sql11);
                                if (!rs11.next()){
                                    String sql12_1 ="insert into uf_ryda_dt4 (mainid,khqc,ljyhzccs) values ("+id+","+khqc+","+1+")";
                                    rs12_1.execute(sql12_1);
                                }else {
                                    rs11_2.execute(sql11);
                                    while (rs11_2.next()){
                                        String ljyhzccs1 =rs11_2.getString("ljyhzccs");
                                        if (ljyhzccs1.equals("")){
                                            ljyhzccs1="0";
                                        }
                                        int ljyhzccs2=Integer.valueOf(ljyhzccs1)+1;

                                        sql12="update uf_ryda_dt4 set ljyhzccs="+ljyhzccs2+" where mainid = "+id+" and khqc="+khqc;
                                        rs12.execute(sql12);
                                    }
                                }
                            }

                            boolean a2 = bgzlfsd <= bgzdf && bgzlfsd >= bgzlfsx && fzgzlx.equals("0");
                            new BaseBean().writeLog(">>>>>>>>>>>>>>结果<<<<<<<<<" + a2);
                            if (bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("0")) {//若“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”，且“分值规则类型”为“增加”时
                                new BaseBean().writeLog(">>增加1<");
                                if(sfdl.equals("0")){//“是否独立”为“是”
                                    ljyhzccs =ljyhzccs+1;
                                    dlhzccs = dlhzccs+1;
                                    //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>sql8<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                        dlnlfz = dlnlfz+ zcfz;
                                        ljnlfz = ljnlfz+zcfz;
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql9="update  uf_ryda_dt2 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"',dlhzccs='"+dlhzccs+"'  where mainid="+id+" and fwxl="+fwxl;
                                        new BaseBean().writeLog(">>sql9<"+sql9);
                                        rs9.execute(sql9);
                                    }
                                }else {//“是否独立”为“否”
                                    new BaseBean().writeLog(">>“是否独立”为“否”<");
                                    ljyhzccs =ljyhzccs+1;
                                    //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>“是否独立”为“否”<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        new BaseBean().writeLog(">>“组长分值”<"+zcfz);
                                        //“组长分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                        ljnlfz = ljnlfz+zcfz;
                                        //更新“独立能力分值”和“累计能力分值”
                                        new BaseBean().writeLog(">>“独立能力分值”<"+ljnlfz);
                                        sql9="update  uf_ryda_dt2 set ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"' where mainid="+id+" and fwxl="+fwxl;
                                        new BaseBean().writeLog(">>sql19<"+sql9);
                                        rs9.execute(sql9);
                                    }
                                }
                            }else if (bgzdf<=bgzlfsd  && bgzdf >= bgzlfsx && fzgzlx.equals("1")){
                                new BaseBean().writeLog(">>减少1<");
                                if(sfdl.equals("0")){

                                    //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>sql8<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                        dlnlfz = dlnlfz-zcfz;
                                        if(dlnlfz<0){
                                            dlnlfz=0;
                                        }
                                        ljnlfz = ljnlfz-zcfz;
                                        if(ljnlfz<0){
                                            ljnlfz=0;
                                        }
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql9="update  uf_ryda_dt2 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"',dlhzccs='"+dlhzccs+"' where mainid="+id+" and fwxl="+fwxl;
                                        new BaseBean().writeLog(">>sql9<"+sql9);
                                        rs9.execute(sql9);
                                    }
                                }else {
                                    new BaseBean().writeLog(">>“是否独立”为“否”<");

                                    //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>“是否独立”为“否”<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                        ljnlfz = ljnlfz-zcfz;
                                        if(ljnlfz<0){
                                            ljnlfz=0;
                                        }
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql9="update  uf_ryda_dt2 set ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"' where mainid="+id+" and fwxl="+fwxl;
                                        new BaseBean().writeLog(">>sql9<"+sql9);
                                        rs9.execute(sql9);
                                    }
                                }
                            }
                        }


                    }
                    new BaseBean().writeLog(">>>>>>>>>>>>>>执行到这边<<<<<<<<<");
                    rs5_2.execute(sql5);
                    while (rs5_2.next()){
                        new BaseBean().writeLog(">>>>>>>>>>>>>>组长，产品中类<<<<<<<<<");
                        String sfdl =rs5_2.getString("sfdl");//是否独立
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“sfdl:<<<<<<<<<"+sfdl);
                        String a11 =rs5_2.getString("dlnlfz");
                        if (a11.equals("")){
                            a11="0";
                        }
                        int dlnlfz = Integer.valueOf(a11);
                        //int dlnlfz =Integer.valueOf(rs4_2.getString("dlnlfz")==null?"0":rs4_2.getString("dlnlfz"));//独立能力分值
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“dlnlfz:<<<<<<<<<"+dlnlfz);
                        String a12 =rs5_2.getString("ljnlfz");
                        if (a12.equals("")){
                            a12="0";
                        }
                        int ljnlfz = Integer.valueOf(a12);
                        //int ljnlfz = Integer.valueOf(rs4_2.getString("ljnlfz")==null?"0":rs4_2.getString("ljnlfz"));//累计能力分值
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“ljnlfz:<<<<<<<<<"+ljnlfz);
                        String a13 =rs5_2.getString("ljyhzccs");
                        if (a13.equals("")){
                            a13="0";
                        }
                        int ljyhzccs = Integer.valueOf(a13);
                        //int ljyhzccs =Integer.valueOf(rs4_2.getString("ljyhzycs")==null?"0":rs4_2.getString("ljyhzycs"));//累计验货组长次数
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“ljyhzccs:<<<<<<<<<"+ljyhzccs);
                        String a14 =rs5_2.getString("dlhzccs");
                        if (a14.equals("")){
                            a14="0";
                        }
                        int dlhzccs = Integer.valueOf(a14);
                        //int dlhzccs =Integer.valueOf(rs4_2.getString("dlhzccs")==null?"0":rs4_2.getString("dlhzccs"));//独立后组长次数
                        new BaseBean().writeLog(">>>>>>>>>>>>>>“dlhzccs:<<<<<<<<<"+dlhzccs);
                        sql= "select * from uf_rynlfzgzb where ysfdl ="+sfdl;//人员能力分值规则表信息
                        rs.execute(sql);
                        while (rs.next()) {
                            String sb  = rs.getString("bgzlfsd");
                            if(sb.equals("")) {
                                new BaseBean().writeLog("空");
                                continue ;
                            }
                            BigDecimal a = new BigDecimal(rs.getString("bgzlfsd"));
                            int bgzlfsd = a.intValue();//报告质量分数（大）
                            BigDecimal a1 = new BigDecimal(rs.getString("bgzlfsx"));
                            int bgzlfsx = a1.intValue();//报告质量分数（小）
                            fzgzlx = rs.getString("fzgzlx");//分值规则类型


                            boolean a2 = bgzlfsd <= bgzdf && bgzlfsd >= bgzlfsx && fzgzlx.equals("0");
                            new BaseBean().writeLog(">>>>>>>>>>>>>>结果<<<<<<<<<" + a2);
                            if (bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("0")) {//“分值规则类型”为“增加”
                                if (sfdl.equals("0")) {
                                    ljyhzccs = ljyhzccs + 1;
                                    dlhzccs = dlhzccs + 1;
                                    //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                    sql8 = "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf + " and fzgzlx=" + fzgzlx;
                                    new BaseBean().writeLog(">>sql8<" + sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()) {
                                        int zcfz = Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                        dlnlfz = dlnlfz + zcfz;
                                        ljnlfz = ljnlfz + zcfz;
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql10 = "update  uf_ryda_dt1 set dlnlfz ='" + dlnlfz + "',ljnlfz='" + ljnlfz + "',ljyhzccs='" + ljyhzccs + "',dlhzccs='" + dlhzccs + "' where mainid=" + id + " and cpzl=" + cpzl;
                                        new BaseBean().writeLog(">>sql10<" + sql10);
                                        rs10.execute(sql10);
                                    }
                                } else {
                                    new BaseBean().writeLog(">>“是否独立”为“否”<");
                                    ljyhzccs = ljyhzccs + 1;
                                    //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                    sql8 = "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf + " and fzgzlx=" + fzgzlx;
                                    new BaseBean().writeLog(">>“是否独立”为“否”<" + sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()) {
                                        int zcfz = Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                        ljnlfz = ljnlfz + zcfz;
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql10 = "update  uf_ryda_dt1 set ljnlfz='" + ljnlfz + "',ljyhzccs='" + ljyhzccs + "' where mainid=" + id + " and cpzl=" + cpzl;
                                        new BaseBean().writeLog(">>sql10<" + sql10);
                                        rs10.execute(sql10);
                                    }
                                }
                            }else if(bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("1")){
                                if(sfdl.equals("0")){

                                    //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>sql8<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                        dlnlfz = dlnlfz- zcfz;
                                        if(dlnlfz<0){
                                            dlnlfz=0;
                                        }
                                        ljnlfz = ljnlfz-zcfz;
                                        if(ljnlfz<0){
                                            ljnlfz=0;
                                        }
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql10="update  uf_ryda_dt1 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"',dlhzccs='"+dlhzccs+"' where mainid="+id+" and cpzl="+cpzl;
                                        new BaseBean().writeLog(">>sql10<"+sql10);
                                        rs10.execute(sql10);
                                    }
                                }else {
                                    new BaseBean().writeLog(">>“是否独立”为“否”<");

                                    //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                    sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                    new BaseBean().writeLog(">>“是否独立”为“否”<"+sql8);
                                    rs8.execute(sql8);
                                    while (rs8.next()){
                                        int zcfz =Integer.valueOf(rs8.getString("zcfz"));//组长分值
                                        //“组长分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                        ljnlfz = ljnlfz-zcfz;
                                        if(ljnlfz<0){
                                            ljnlfz=0;
                                        }
                                        //更新“独立能力分值”和“累计能力分值”
                                        sql10="update  uf_ryda_dt1 set ljnlfz='"+ljnlfz+"',ljyhzccs='"+ljyhzccs+"' where mainid="+id+" and cpzl="+cpzl;
                                        new BaseBean().writeLog(">>sql10<"+sql10);
                                        rs10.execute(sql10);
                                    }
                                }
                            }

                        }
                    }



                }
            }else if (yhyxz.equals("1")){
                //验货员为组员
                sql3="select * from uf_ryda where rymc="+yhy;//人员能力表中人员对应的id（对应人员能力表明细2中的mainid）
                rs3.execute(sql3);
                while (rs3.next()){
                    id= rs3.getString("id");
                    sql4="select * from uf_ryda_dt2 where mainid="+id+" and fwxl="+fwxl;//人员能力表“明细表2，uf_ryda_dt2中的服务小类下对应组员的信息
                    sql5="select * from uf_ryda_dt1 where mainid="+id+" and cpzl="+cpzl;//人员能力表“明细表1，uf_ryda_dt1中的产品中类下对应组长的信息
                    rs13.execute(sql4);
                    boolean rs15_1=rs13.next();
                    new BaseBean().writeLog(">>>>>>>>>>>>>>组员，服务小类<<<<<<<<<"+sql4);
                    //产品小类
                    if (!rs15_1) {//若“人员能力表”中“明细表2”没有该类的产品能力数据时，直接增加数据
                        new BaseBean().writeLog(">>>>>>>>>>>>>>组员，服务小类，增加数据<<<<<<<<<");
                        sql6 = "insert into uf_ryda_dt2 (mainid,fwdl,fwzl,fwxl,sfdl,sfzdrd,dlnlfz,ljnlfz,ljyhzycs,dlhzccs) values (" + id + ",'" + fwdl + "','" + fwzl + "','" + fwxl + "'," + 1 + "," + sfzdrdx + ",'" + 0 + "','" + 0 + "','" + 0 + "','" + 0 + "')";
                        rs6.execute(sql6);
                    }

                    rs5.execute(sql5);
                    if (!rs5.next()) {//若“人员能力表”中“明细表1”没有该类的产品能力数据时，直接增加数据
                        new BaseBean().writeLog(">>>>>>>>>>>>>>组员，产品中类，增加数据<<<<<<<<<");
                        sql7 = "insert into uf_ryda_dt1 (mainid,cpdl,cpzl,sfdl,sfzdrd,dlnlfz,ljnlfz,ljyhzccs,dlhzccs) values (" + id + ",'" + cpdl + "','" + cpzl + "'," + 1 + "," + sfzdrdz + ",'" + 0 + "','" + 0 + "','" + 0 + "','" + 0 + "')";
                        rs7.execute(sql7);
                    }
                        rs4_2.execute(sql4);
                        while (rs4_2.next()){
                            String sfdl =rs4_2.getString("sfdl");//是否独立
                            String a11=rs4_2.getString("dlnlfz");
                            if (a11.equals("")){
                                a11="0";
                            }
                            int dlnlfz =Integer.valueOf(a11);
                            //int dlnlfz =Integer.valueOf(rs4_2.getString("dlnlfz")==null?"0":rs4_2.getString("dlnlfz"));//独立能力分值
                            String a12=rs4_2.getString("ljnlfz");
                            if (a12.equals("")){
                                a12="0";
                            }
                            int ljnlfz =Integer.valueOf(a12);
                            //int ljnlfz = Integer.valueOf(rs4_2.getString("ljnlfz")==null?"0":rs4_2.getString("ljnlfz"));//累计能力分值
                            String a13=rs4_2.getString("ljyhzycs");
                            if (a13.equals("")){
                                a13="0";
                            }
                            int ljyhzycs =Integer.valueOf(a13);
                            //int ljyhzycs =Integer.valueOf(rs4_2.getString("ljyhzycs")==null?"0":rs4_2.getString("ljyhzycs"));//累计验货组员次数
                            String a14=rs4_2.getString("dlhzycs");
                            if (a14.equals("")){
                                a14="0";
                            }
                            int dlhzycs =Integer.valueOf(a14);
                            //int dlhzycs =Integer.valueOf(rs4_2.getString("dlhzycs")==null?"0":rs4_2.getString("dlhzycs"));//独立后组员次数
                            sql= "select * from uf_rynlfzgzb where ysfdl ="+sfdl;//人员能力分值规则表信息
                            rs.execute(sql);
                            while (rs.next()) {
                                String sb  = rs.getString("bgzlfsd");
                                if(sb.equals("")) {
                                    new BaseBean().writeLog("空");
                                    continue ;
                                }
                                BigDecimal a = new BigDecimal(rs.getString("bgzlfsd"));
                                int bgzlfsd = a.intValue();//报告质量分数（大）
                                BigDecimal a1 = new BigDecimal(rs.getString("bgzlfsx"));
                                int bgzlfsx = a1.intValue();//报告质量分数（小）
                                fzgzlx = rs.getString("fzgzlx");//分值规则类型
                                new BaseBean().writeLog(">客户全称规则类型<"+fzgzlx);
                                //客户名称
                                if(fzgzlx.equals("0")){
                                    sql11="select * from uf_ryda_dt4 where mainid="+id+" and khqc="+khqc;
                                    rs11.execute(sql11);
                                    if (!rs11.next()){
                                        String sql12_1 ="insert into uf_ryda_dt4 (mainid,khqc,ljyhzycs) values ("+id+","+khqc+",'"+1+"')";
                                        rs12_1.execute(sql12_1);
                                    }else {
                                        rs11_2.execute(sql11);
                                        while (rs11_2.next()){
                                            String ljyhzycs1 =rs11_2.getString("ljyhzycs");
                                            if (ljyhzycs1.equals("")){
                                                ljyhzycs1="0";
                                            }
                                            int ljyhzycs2=Integer.valueOf(ljyhzycs1)+1;

                                            sql12="update uf_ryda_dt4 set ljyhzycs='"+ljyhzycs2+"' where mainid = "+id+" and khqc="+khqc;
                                            rs12.execute(sql12);
                                        }
                                    }
                                }
                                boolean a2 = bgzlfsd <= bgzdf && bgzlfsd >= bgzlfsx && fzgzlx.equals("0");
                                new BaseBean().writeLog(">>>>>>>>>>>>>>结果<<<<<<<<<" + a2);
                                if (bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("0")) {
                                    if(sfdl.equals("0")){//独立
                                        ljyhzycs =ljyhzycs+1;
                                        dlhzycs = dlhzycs+1;
                                        //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                            dlnlfz = dlnlfz+ zyfz;
                                            ljnlfz = ljnlfz+zyfz;
                                            //更新“独立能力分值”和“累计能力分值”、“累计验货组员次数”
                                            sql9="update  uf_ryda_dt2 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"',dlhzycs='"+dlhzycs+"' where mainid="+id+" and fwxl="+fwxl;
                                            rs9.execute(sql9);
                                        }
                                    }else {
                                        ljyhzycs =ljyhzycs+1;
                                        //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                            ljnlfz = ljnlfz+zyfz;
                                            //更新“独立能力分值”和“累计验货组员次数”
                                            sql9="update  uf_ryda_dt2 set ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"' where mainid="+id+" and fwxl="+fwxl;
                                            rs9.execute(sql9);
                                        }
                                    }
                                }else if(bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("1")){
                                    if(sfdl.equals("0")){//独立

                                        //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                            dlnlfz = dlnlfz- zyfz;
                                            if(dlnlfz<0){
                                                dlnlfz=0;
                                            }
                                            ljnlfz = ljnlfz-zyfz;
                                            if(ljnlfz<0){
                                                ljnlfz=0;
                                            }
                                            //更新“独立能力分值”和“累计能力分值”、“累计验货组员次数”
                                            sql9="update  uf_ryda_dt2 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"',dlhzycs='"+dlhzycs+"' where mainid="+id+" and fwxl="+fwxl;
                                            rs9.execute(sql9);
                                        }
                                    }else {

                                        //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                            ljnlfz = ljnlfz-zyfz;
                                            if(ljnlfz<0){
                                                ljnlfz=0;
                                            }
                                            //更新“独立能力分值”和“累计验货组员次数”
                                            sql9="update  uf_ryda_dt2 set ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"' where mainid="+id+" and fwxl="+fwxl;
                                            rs9.execute(sql9);
                                        }
                                    }
                                }
                            }}

                       }
                    //产品中类
                        new BaseBean().writeLog(">>>>>>>>>>>>>>组员，产品中类<<<<<<<<<");
                        rs5_2.execute(sql5);
                        while (rs5_2.next()){
                            new BaseBean().writeLog(">>>>>>>>>>>>>>执行<<<<<<<<<"+sql5);
                            String sfdl =rs5_2.getString("sfdl");//是否独立
                            String a11=rs5_2.getString("dlnlfz");
                            if (a11.equals("")){
                                a11="0";
                            }
                            int dlnlfz =Integer.valueOf(a11);
                            //int dlnlfz =Integer.valueOf(rs4_2.getString("dlnlfz")==null?"0":rs4_2.getString("dlnlfz"));//独立能力分值
                            String a12=rs5_2.getString("ljnlfz");
                            if (a12.equals("")){
                                a12="0";
                            }
                            int ljnlfz =Integer.valueOf(a12);
                            //int ljnlfz = Integer.valueOf(rs4_2.getString("ljnlfz")==null?"0":rs4_2.getString("ljnlfz"));//累计能力分值
                            String a13=rs5_2.getString("ljyhzycs");
                            if (a13.equals("")){
                                a13="0";
                            }
                            int ljyhzycs =Integer.valueOf(a13);
                            //int ljyhzycs =Integer.valueOf(rs4_2.getString("ljyhzycs")==null?"0":rs4_2.getString("ljyhzycs"));//累计验货组员次数
                            String a14=rs5_2.getString("dlhzycs");
                            if (a14.equals("")){
                                a14="0";
                            }
                            int dlhzycs =Integer.valueOf(a14);
                            //int dlhzycs =Integer.valueOf(rs4_2.getString("dlhzycs")==null?"0":rs4_2.getString("dlhzycs"));//独立后组员次数
                            sql= "select * from uf_rynlfzgzb where ysfdl ="+sfdl;//人员能力分值规则表信息
                            new BaseBean().writeLog(">>>>>>>>>>>>>>执行1<<<<<<<<<"+sql);
                            rs.execute(sql);
                            while (rs.next()) {
                                String sb  = rs.getString("bgzlfsd");
                                if(sb.equals("")) {
                                    new BaseBean().writeLog("空");
                                    continue ;
                                }
                                BigDecimal a = new BigDecimal(rs.getString("bgzlfsd"));
                                int bgzlfsd = a.intValue();//报告质量分数（大）
                                BigDecimal a1 = new BigDecimal(rs.getString("bgzlfsx"));
                                int bgzlfsx = a1.intValue();//报告质量分数（小）
                                fzgzlx = rs.getString("fzgzlx");//分值规则类型

                                boolean a2 = bgzlfsd <= bgzdf && bgzlfsd >= bgzlfsx && fzgzlx.equals("0");
                                new BaseBean().writeLog(">>>>>>>>>>>>>>结果<<<<<<<<<" + a2);
                                if (bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("0")) {
                                    if(sfdl.equals("0")){//独立
                                        ljyhzycs =ljyhzycs+1;
                                        dlhzycs = dlhzycs+1;
                                        //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                            dlnlfz = dlnlfz+ zyfz;
                                            ljnlfz = ljnlfz+zyfz;
                                            //更新“独立能力分值”和“累计能力分值”、“累计验货组员次数”
                                            sql10="update  uf_ryda_dt1 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"',dlhzycs='"+dlhzycs+"' where mainid="+id+" and cpzl="+cpzl;
                                            rs10.execute(sql10);
                                        }
                                    }else {
                                        ljyhzycs =ljyhzycs+1;
                                        //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“增加”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                            ljnlfz = ljnlfz+zyfz;
                                            //更新“独立能力分值”和“累计验货组员次数”
                                            sql10="update  uf_ryda_dt1 set ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"' where mainid="+id+" and cpzl="+cpzl;
                                            rs10.execute(sql10);
                                        }
                                    }
                                }else if(bgzdf<=bgzlfsd && bgzdf >= bgzlfsx && fzgzlx.equals("1")){
                                    if(sfdl.equals("0")){//独立

                                        //“是否独立”为“是”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=0 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组长分值”分别加到“人员能力表”中“明细表2”中的“独立能力分值”和“累计能力分值”
                                            dlnlfz = dlnlfz- zyfz;
                                            if(dlnlfz<0){
                                                dlnlfz=0;
                                            }
                                            ljnlfz = ljnlfz-zyfz;
                                            if(ljnlfz<0){
                                                ljnlfz=0;
                                            }
                                            //更新“独立能力分值”和“累计能力分值”、“累计验货组员次数”
                                            sql10="update  uf_ryda_dt1 set dlnlfz ='"+dlnlfz+"',ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"',dlhzycs='"+dlhzycs+"' where mainid="+id+" and cpzl="+cpzl;
                                            rs10.execute(sql10);
                                        }
                                    }else {

                                        //“是否独立”为“否”,“规则类型”为“报告质量分数”、“报告质量分数（大）”小于等于“报告总得分”大于等于“报告质量分数（小）”、“分值规则类型”为“减少”到“人员能力分值规则表”中取出“组长分值”
                                        sql8= "select * from uf_rynlfzgzb where ysfdl=1 and gzlx=1 and bgzlfsd>=" + bgzdf + " and bgzlfsx<=" + bgzdf+" and fzgzlx="+fzgzlx;
                                        rs8.execute(sql8);
                                        while (rs8.next()){
                                            int zyfz =Integer.valueOf(rs8.getString("zyfz"));//组员分值
                                            //“组员分值”加到“人员能力表”中“明细表2”中的“累计能力分值”
                                            ljnlfz = ljnlfz-zyfz;
                                            if(ljnlfz<0){
                                                ljnlfz=0;
                                            }
                                            //更新“独立能力分值”和“累计验货组员次数”
                                            sql10="update  uf_ryda_dt1 set ljnlfz='"+ljnlfz+"',ljyhzycs='"+ljyhzycs+"' where mainid="+id+" and cpzl="+cpzl;
                                            rs10.execute(sql10);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        json.put("code", "200");
        json.put("msg", "更新成功！");
    } catch (Exception e) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw, true));
        String str = sw.toString();
        json.put("code", "202");
        json.put("msg", "系统接口出错！");
        new BaseBean().writeLog(">>>>>>>>>>>>>>出错<<<<<<<<<"+str);
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());
%>