<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**     质控管理
     *      ZK30服务人员变更申请
     *      zys
     *      20210806
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行服务人员变更操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String bglx = request.getParameter("bglx");//变更类型
    String bgfs = request.getParameter("bgfs");//变更方式
    String thry = request.getParameter("thry");//替换人员
    String fwrybglx = request.getParameter("fwrybglx");//服务人员变更类型
    String khjl =request.getParameter("khjl");//客户经理
    String khjl2 =request.getParameter("khjl2");//客服经理助理
    String khjl3 =request.getParameter("khjl3");//质量经理
    String khjl4 =request.getParameter("khjl4");//产品经理
    String khjl5 =request.getParameter("khjl5");//报告审核员
    String khjl6 =request.getParameter("khjl6");//资料审核员
    String khjl7 =request.getParameter("khjl7");//报价员
    String khjl8 =request.getParameter("khjl8");//翻译员
    String khjl9 =request.getParameter("khjl9");//大客户经理
    String sql="";
    String sb="";
    String dlr ="";
    String lx="";
    try {
        String fw[]=fwrybglx.split(",");

        for (int i = 0; i <fw.length ; i++) {
            lx = fw[i].toString();
            new BaseBean().writeLog(">>>>>>>>>>>>>>服务人员类型<<<<<<<<<"+lx);
            if (lx.equals("0")) {
                sb = "uf_khgl_dt2";
                dlr = "cs";
            } else if (lx.equals("1")) {
                sb = "uf_khgl_dt2";
                dlr = "cszl";
            } else if (lx.equals("2")) {
                sb = "uf_khgl_dt3";
                dlr = "zljl";
            } else if (lx.equals("3")) {
                sb = "uf_khgl_dt5";
                dlr = "cpjl";
            } else if (lx.equals("4")) {
                sb = "uf_khgl_dt6";
                dlr = "bgshy";
            } else if (lx.equals("5")) {
                sb = "uf_khgl_dt6";
                dlr = "zlshy";
            } else if (lx.equals("6")) {
                sb = "uf_khgl_dt6";
                dlr = "bjy";
            } else if (lx.equals("7")) {
                sb = "uf_khgl_dt7";
                dlr = "fyy";
            } else if (lx.equals("8")) {
                sb = "uf_khgl_dt9";
                dlr = "dkhjl";
            }
            new BaseBean().writeLog(">>>>>>>>>>>>>>变更类型<<<<<<<<<"+bglx+",变更方式："+bgfs);
            if (bglx.equals("1") && bgfs.equals("0")) {
                sql = "update " + sb + " set " + dlr + "=" + thry;
                rs.execute(sql);
            } else if (bglx.equals("1") && bgfs.equals("1")) {

                if (lx.equals("0")) {
                    String khjlz[] = khjl.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt1 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("1")) {
                    String khjlz[] = khjl2.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt2 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("2")) {
                    String khjlz[] = khjl3.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt3 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("3")) {
                    String khjlz[] = khjl4.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt4 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("4")) {
                    String khjlz[] = khjl5.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt5 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("5")) {
                    String khjlz[] = khjl6.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt6 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("6")) {
                    String khjlz[] = khjl7.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt7 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("7")) {
                    String khjlz[] = khjl8.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt8 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                } else if (lx.equals("8")) {
                    String khjlz[] = khjl9.split(",");
                    for (int j = 0; j < khjlz.length; j++) {
                        String khqc = khjlz[0].toString();
                        String thryk = khjlz[1].toString();
                        sql = "update formtable_main_775_dt1 set thry=" + thryk + " where khqc=" + khqc;
                        rs.execute(sql);
                    }
                }
            }

        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>



