<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      合规管理接口
     *      CAPA申请
     *      分值减
     *      zys
     *      20210520
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行CAPA申请操作<<<<<<<<<");
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
    JSONObject json = new JSONObject();
    String yhy11 = request.getParameter("yhy");//验货员
    String yhy1[] = yhy11.split("~");
    new BaseBean().writeLog(">>>>>>>>>>>>>>验货员1<<<<<<<<<"+yhy11);
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
    String id="";
    try {
        for (int i=0;i<yhy1.length;i++){
            String yhy_1 = yhy1[i].toString();
            String yhy_2[]=yhy_1.split(",");
            String bgh= yhy_2[0].toString();
            String xzfl =yhy_2[1].toString();
            if (xzfl.equals("0")||xzfl.equals("1")||xzfl.equals("2")){
                sql1="select * from formtable_main_814 where bgh ="+bgh;
                rs1.execute(sql1);
                while (rs1.next()){
                    String mainid = rs1.getString("id");//
                    String fwxl = rs1.getString("fwxl");//服务小类
                    String cpzl = rs1.getString("cpzl");//产品中类

                    sql2="select * from formtable_main_814_dt4 where mainid="+mainid;
                    new BaseBean().writeLog(">>>>>>>>>>1<<<<<<<<<"+sql2);
                    rs2.execute(sql2);
                    while (rs2.next()){
                        String yhy = rs2.getString("yhy");//验货员
                        String yhyxz = rs2.getString("yhyxz");//验货员性质
                        new BaseBean().writeLog(">>>>>>>>>>>>>>11<<<<<<<<<"+yhy);
                        if(yhyxz.equals("0")){//组长
                            sql7="select * from uf_ryda where rymc="+yhy;//人员能力表中人员对应的id（对应人员能力表明细2中的mainid）
                            rs7.execute(sql7);
                            new BaseBean().writeLog(">>>>>>>>>>>>>>2<<<<<<<<<"+sql7);
                            while (rs7.next()){
                                id= rs7.getString("id");
                                sql3="select * from uf_ryda_dt2 where mainid="+id+ " and fwxl="+fwxl;//把组长和“检验报告申请”主表“服务小类”（fwxl）字段到“人员能力表”（uf_ryda）中明细表2判断服务能力是否独立
                                new BaseBean().writeLog(">>>>>>>>>>>>>>sql3<<<<<<<<<"+sql3);
                                rs3.execute(sql3);
                                while (rs3.next()){
                                    String id1 = rs3.getString("id");
                                    String sfdl = rs3.getString("sfdl");
                                    int dlnlfz =Integer.parseInt(rs3.getString("dlnlfz"));//独立能力分值
                                    int ljnlfz = Integer.parseInt(rs3.getString("ljnlfz"));//累计能力分值
                                    //int ljyhzccs =Integer.valueOf(rs4.getString("ljyhzccs"));//累计验货组长次数
                                    //int dlhzccs =Integer.valueOf(rs4.getString("dlhzccs"));//独立后组长次数
                                    new BaseBean().writeLog(">>>>>>>>>>>>>>3<<<<<<<<<");
                                    if (sfdl.equals("0")){//是否独立为是
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and fzgzlx=1 and tsyzcd="+xzfl;
                                        new BaseBean().writeLog(">>>>>>>>>>>>>>sql4<<<<<<<<<"+sql4);
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zcfz = Integer.valueOf(rs4.getString("zcfz"));
                                            dlnlfz =dlnlfz-zcfz;
                                            ljnlfz = ljnlfz-zcfz;
                                            if (dlnlfz<=0){
                                                dlnlfz=0;
                                            }
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt2 set dlnlfz="+dlnlfz+",ljnlfz="+ljnlfz+" where id="+id1;
                                            new BaseBean().writeLog(">>>>>>>>>>>>>>sql5<<<<<<<<<"+sql5);
                                            rs5.execute(sql5);
                                        }
                                    }else if(sfdl.equals("1")){//是否独立为否
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zcfz = Integer.valueOf(rs4.getString("zcfz"));
                                            ljnlfz = ljnlfz-zcfz;
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt2 set ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }
                                }
                                new BaseBean().writeLog(">>>>>>>>>>>>>>4<<<<<<<<<");
                                sql6="select * from uf_ryda_dt1 where mainid="+id+" and cpzl="+cpzl;//把组长和“检验报告申请”主表“产品中类cpzl”字段到“人员能力表”（uf_ryda）中“明细表1，uf_ryda_dt1” 判断服务能力是否独立
                                rs6.execute(sql6);
                                while (rs6.next()){
                                    String id1 = rs6.getString("id");
                                    String sfdl = rs6.getString("sfdl");
                                    int dlnlfz =Integer.parseInt(rs6.getString("dlnlfz"));//独立能力分值
                                    int ljnlfz = Integer.parseInt(rs6.getString("ljnlfz"));//累计能力分值
                                    //int ljyhzccs =Integer.valueOf(rs4.getString("ljyhzccs"));//累计验货组长次数
                                    //int dlhzccs =Integer.valueOf(rs4.getString("dlhzccs"));//独立后组长次数
                                    if (sfdl.equals("0")){//是否独立为是
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and  fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zcfz = Integer.valueOf(rs4.getString("zcfz"));
                                            dlnlfz =dlnlfz-zcfz;
                                            ljnlfz = ljnlfz-zcfz;
                                            if (dlnlfz<=0){
                                                dlnlfz=0;
                                            }
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt1 set dlnlfz="+dlnlfz+",ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }else if(sfdl.equals("1")){//是否独立为否
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zcfz = Integer.valueOf(rs4.getString("zcfz"));
                                            ljnlfz = ljnlfz-zcfz;
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt1 set ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }
                                }
                            }


                        }else{
                            //组员
                            sql7="select * from uf_ryda where rymc="+yhy;//人员能力表中人员对应的id（对应人员能力表明细2中的mainid）
                            rs7.execute(sql7);
                            new BaseBean().writeLog(">>>>>>>>>>>>>>组员1<<<<<<<<<"+sql7);
                            while (rs7.next()){
                                id=rs7.getString("id");
                                sql3="select * from uf_ryda_dt2 where mainid="+id+ " and fwxl="+fwxl;//把组员和“检验报告申请”主表“服务小类”（fwxl）字段到“人员能力表”（uf_ryda）中明细表2判断服务能力是否独立
                                rs3.execute(sql3);
                                new BaseBean().writeLog(">>>>>>>>>>>>>>组员2<<<<<<<<<"+sql3);
                                while (rs3.next()){
                                    String id1 = rs3.getString("id");
                                    String sfdl = rs3.getString("sfdl");
                                    new BaseBean().writeLog(">>>>>>>>>>>>>>组员22<<<<<<<<<");
                                    int dlnlfz =Integer.parseInt(rs3.getString("dlnlfz"));//独立能力分值
                                    int ljnlfz = Integer.parseInt(rs3.getString("ljnlfz"));//累计能力分值
                                    new BaseBean().writeLog(">>>>>>>>>>>>>>组员222<<<<<<<<<");
                                    //int ljyhzccs =Integer.valueOf(rs4.getString("ljyhzccs"));//累计验货组长次数
                                    //int dlhzccs =Integer.valueOf(rs4.getString("dlhzccs"));//独立后组长次数
                                    if (sfdl.equals("0")){//是否独立为是
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and  fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        new BaseBean().writeLog(">>>>>>>>>>>>>>组员3<<<<<<<<<"+sql4);
                                        while (rs4.next()){
                                            int zyfz = Integer.valueOf(rs4.getString("zyfz"));
                                            dlnlfz =dlnlfz-zyfz;
                                            ljnlfz = ljnlfz-zyfz;
                                            if (dlnlfz<=0){
                                                dlnlfz=0;
                                            }
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt2 set dlnlfz="+dlnlfz+",ljnlfz="+ljnlfz+" where id="+id1;
                                            new BaseBean().writeLog(">>>>>>>>>>>>>>sql5<<<<<<<<<"+sql5);
                                            rs5.execute(sql5);
                                        }
                                    }else if(sfdl.equals("1")){//是否独立为否
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0  and fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zyfz = Integer.valueOf(rs4.getString("zyfz"));
                                            ljnlfz = ljnlfz-zyfz;
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt2 set ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }
                                }
                                sql6="select * from uf_ryda_dt1 where mainid="+id+" and cpzl="+cpzl;//把组员和“检验报告申请”主表“产品中类cpzl”字段到“人员能力表”（uf_ryda）中“明细表1，uf_ryda_dt1” 判断服务能力是否独立
                                rs6.execute(sql6);
                                while (rs6.next()){
                                    String id1 = rs6.getString("id");
                                    String sfdl = rs6.getString("sfdl");
                                    int dlnlfz =Integer.parseInt(rs6.getString("dlnlfz"));//独立能力分值
                                    int ljnlfz = Integer.parseInt(rs6.getString("ljnlfz"));//累计能力分值
                                    //int ljyhzccs =Integer.valueOf(rs4.getString("ljyhzccs"));//累计验货组长次数
                                    //int dlhzccs =Integer.valueOf(rs4.getString("dlhzccs"));//独立后组长次数
                                    if (sfdl.equals("0")){//是否独立为是
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zyfz = Integer.valueOf(rs4.getString("zyfz"));
                                            dlnlfz =dlnlfz-zyfz;
                                            ljnlfz = ljnlfz-zyfz;
                                            if (dlnlfz<=0){
                                                dlnlfz=0;
                                            }
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt1 set dlnlfz="+dlnlfz+",ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }else if(sfdl.equals("1")){//是否独立为否
                                        sql4="select * from uf_rynlfzgzb where ysfdl="+sfdl+" and gzlx=0 and fzgzlx=1 and tsyzcd="+xzfl;
                                        rs4.execute(sql4);
                                        while (rs4.next()){
                                            int zyfz = Integer.valueOf(rs4.getString("zyfz"));
                                            ljnlfz = ljnlfz-zyfz;
                                            if (ljnlfz<=0){
                                                ljnlfz=0;
                                            }
                                            sql5="update uf_ryda_dt1 set ljnlfz="+ljnlfz+" where id="+id1;
                                            rs5.execute(sql5);
                                        }
                                    }
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
        json.put("code", "202");
        json.put("msg", "系统接口出错！");
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw, true));
        String str = sw.toString();
        new BaseBean().writeLog(">>>>>>>>>>>>>>出错<<<<<<<<<"+str);
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());
%>