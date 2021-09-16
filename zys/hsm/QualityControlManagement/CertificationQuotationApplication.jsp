<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**     质控管理
     *      ZK11认证报价申请表单
     *      COC/COI出证费用
     *      zys
     *      20210817
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行认证报价申请COC/COI出证费用操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs_1 = new RecordSet();
    RecordSet rs1 = new RecordSet();
    RecordSet rs1_1 = new RecordSet();
    RecordSet rs2 = new RecordSet();
    RecordSet rs2_1 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    RecordSet rs3_1 = new RecordSet();
    RecordSet rs4 = new RecordSet();
    RecordSet rs4_1 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String ckfphz =request.getParameter("ckfphz");//出口发票货值
    new BaseBean().writeLog(">>>>>>>>>>>>>>ckfphz<<<<<<<<<"+ckfphz);
    String khqc =request.getParameter("khqc");//客户全称
    String ywszjg =request.getParameter("ywgzjg");//业务归属机构
    String fwxl =request.getParameter("fwxl");//服务小类
    String gj =request.getParameter("gj");//服务国家/出证办公室
    String bjbz =request.getParameter("bjbz");//报价币种
    String cpdl =request.getParameter("cpdl");//主产品大类
    String cpzl =request.getParameter("cpzl");//主产品中类
    String cpxl =request.getParameter("cpxl");//主产品小类
    String hgsl= request.getParameter("hgsl");//货柜数量
    String sql="";
    String sql1="";
    String sql2="";
    String sql3="";
    String sql4="";

    int hzfwq;
    int hzfwc;
    String bdj;
    String fdxs="";
    String zkl="";
    String bdjb;
    String zklb="";
    String czfypgfs="";
    String borderfeefy="";
    String borderfeefypgfs="";
    try {
        if(fwxl.equals("500")){//当服务小类为“伊拉克COC”时，分别计算“COC/COI出证费用”和“Border Fee费用”；
            BigDecimal bd=new BigDecimal(ckfphz);
            //设置小数位数，第一个变量是小数位数，第二个变量是取舍方法(四舍五入)
            bd=bd.setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal hgsl1=new BigDecimal(hgsl);
            hgsl1=hgsl1.setScale(2, BigDecimal.ROUND_HALF_UP);
            sql="select * from uf_khgl_dt31 where mainid= "+khqc;
            new BaseBean().writeLog(">>>>>>>>>>>>>>sql<<<<<<<<<"+sql);
            rs.execute(sql);
            if(!rs.next()){
                new BaseBean().writeLog(">>>>>>>>>>>>>>客户档案上没有值<<<<<<<<<"+rs.next());

                sql1="select * from uf_ajzblchg where jgmc="+ywszjg+" and fwxl="+fwxl+" and gj="+gj;
                new BaseBean().writeLog(">>>>>>>>>>>>>>sql1<<<<<<<<<"+sql1);
                rs1.execute(sql1);
                if (!rs1.next()){
                    new BaseBean().writeLog(">>>>>>>>>>>>>>按价值比例（出货港）参数表没有值<<<<<<<<<"+rs1.next());
                    czfypgfs="无";
                    json.put("czfypgfs", czfypgfs);
                    json.put("sfrgpg", "1");
                }
                rs1_1.execute(sql1);
                while (rs1_1.next()){
                    hzfwc=Integer.valueOf(rs1_1.getString("hzfwc"));//货值范围
                    BigDecimal hzfwc1 = new BigDecimal(hzfwc);
                    bdj=rs1_1.getString("bdj");//保底价
                    BigDecimal bdj1 = new BigDecimal(bdj);
                    fdxs=rs1_1.getString("fdxs");//浮动系数
                    BigDecimal xs =new BigDecimal(fdxs);
                    BigDecimal czfy = bd.subtract(hzfwc1).multiply(xs).add(bdj1);
                    json.put("czfy", czfy);
                    json.put("czfypgfs", "服务报价标准报价");
                    json.put("sfrgpg", "0");
                }
            }
            rs_1.execute(sql);
            while (rs_1.next()){
                hzfwc=Integer.valueOf(rs1_1.getString("hzfwc"));//货值范围
                BigDecimal hzfwq1 = new BigDecimal(hzfwc);
                bdj=rs_1.getString("bdj");//保底价
                BigDecimal bdj1 = new BigDecimal(bdj);
                fdxs=rs_1.getString("fdxs");//浮动系数
                BigDecimal xs =new BigDecimal(fdxs);
                zkl=rs_1.getString("zkl");//
                BigDecimal czfy = bd.subtract(hzfwq1).multiply(xs).add(bdj1);
                json.put("coccoiczfyzkl", zkl);
                json.put("czfy", czfy);
                json.put("czfypgfs", "客户档案成交报价");
                json.put("sfrgpg", "0");
            }
            sql2="select * from uf_khgl_dt32 where mainid= "+khqc;
            rs2.execute(sql2);
            if(!rs2.next()){
                new BaseBean().writeLog(">>>>>>>>>>>>>>客户档案上没有值<<<<<<<<<"+rs2.next());

                sql3="select * from uf_ajzblchg where jgmc="+ywszjg+" and fwxl="+fwxl+" and gj="+gj;
                new BaseBean().writeLog(">>>>>>>>>>>>>>sql2<<<<<<<<<"+sql3);
                rs3.execute(sql3);
                if (!rs3.next()){
                    new BaseBean().writeLog(">>>>>>>>>>>>>>按价值比例（出货港）参数表没有值<<<<<<<<<"+rs3.next());
                    borderfeefypgfs="无";
                    json.put("borderfeefypgfs", borderfeefypgfs);
                    json.put("sfrgpg", "1");
                }
                rs3_1.execute(sql3);
                while (rs3_1.next()){
                    hzfwq=Integer.valueOf(rs3_1.getString("hzfwq"));//货值范围
                    BigDecimal hzfwq1 = new BigDecimal(hzfwq);
                    bdjb=rs3_1.getString("bdj");//保底价
                    BigDecimal bdj1 = new BigDecimal(bdjb);
                    fdxs=rs3_1.getString("fdxs");//浮动系数
                    BigDecimal xs =new BigDecimal(fdxs);
                    BigDecimal czfyb = bd.subtract(hzfwq1).multiply(xs).add(bdj1);

                    json.put("czfyb", czfyb);
                    json.put("borderfeefypgfs", "服务报价标准报价");
                    json.put("sfrgpg", "0");
                }
            }
            rs2_1.execute(sql2);
            while (rs2_1.next()){
                hzfwq=Integer.valueOf(rs2_1.getString("hzfwq"));//货值范围
                BigDecimal hzfwq1 = new BigDecimal(hzfwq);
                bdjb=rs2_1.getString("bdj");//保底价
                BigDecimal bdj1 = new BigDecimal(bdjb);
                fdxs=rs2_1.getString("fdxs");//浮动系数
                BigDecimal xs =new BigDecimal(fdxs);
                zklb=rs2_1.getString("zkl");//
                BigDecimal czfyb = ((bd.divide(hgsl1).subtract(hzfwq1)).multiply(xs).add(bdj1)).multiply(hgsl1);
                json.put("borderfeefyzkl", zklb);
                json.put("czfyb", czfyb);
                json.put("borderfeefypgfs", "客户档案成交报价");
                json.put("sfrgpg", "0");
            }
        }else if(fwxl.equals("502")){//当服务小类为“伊拉克COI”时，计算“COC/COI出证费用”；
            BigDecimal bd=new BigDecimal(ckfphz);
            //设置小数位数，第一个变量是小数位数，第二个变量是取舍方法(四舍五入)
            bd=bd.setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal hgsl1=new BigDecimal(hgsl);
            hgsl1=hgsl1.setScale(2, BigDecimal.ROUND_HALF_UP);
            sql="select * from uf_khgl_dt31 where mainid= "+khqc;
            new BaseBean().writeLog(">>>>>>>>>>>>>>sql<<<<<<<<<"+sql);
            rs.execute(sql);
            if(!rs.next()){
                new BaseBean().writeLog(">>>>>>>>>>>>>>客户档案上没有值<<<<<<<<<"+rs.next());

                sql1="select * from uf_ajzblchg where jgmc="+ywszjg+" and fwxl="+fwxl+" and gj="+gj;
                new BaseBean().writeLog(">>>>>>>>>>>>>>sql1<<<<<<<<<"+sql1);
                rs1.execute(sql1);
                if (!rs1.next()){
                    new BaseBean().writeLog(">>>>>>>>>>>>>>按价值比例（出货港）参数表没有值<<<<<<<<<"+rs1.next());
                    czfypgfs="无";
                    json.put("czfypgfs", czfypgfs);
                    json.put("sfrgpg", "1");
                }
                rs1_1.execute(sql1);
                while (rs1_1.next()){
                    hzfwc=Integer.valueOf(rs1_1.getString("hzfwc"));//货值范围
                    BigDecimal hzfwc1 = new BigDecimal(hzfwc);
                    bdj=rs1_1.getString("bdj");//保底价
                    BigDecimal bdj1 = new BigDecimal(bdj);
                    fdxs=rs1_1.getString("fdxs");//浮动系数
                    BigDecimal xs =new BigDecimal(fdxs);
                    BigDecimal czfy = bd.subtract(hzfwc1).multiply(xs).add(bdj1);
                    json.put("czfy", czfy);
                    json.put("czfypgfs", "服务报价标准报价");
                    json.put("sfrgpg", "0");
                }
            }
            rs_1.execute(sql);
            while (rs_1.next()){
                hzfwc=Integer.valueOf(rs1_1.getString("hzfwc"));//货值范围
                BigDecimal hzfwq1 = new BigDecimal(hzfwc);
                bdj=rs_1.getString("bdj");//保底价
                BigDecimal bdj1 = new BigDecimal(bdj);
                fdxs=rs_1.getString("fdxs");//浮动系数
                BigDecimal xs =new BigDecimal(fdxs);
                zkl=rs_1.getString("zkl");//
                BigDecimal czfy = bd.subtract(hzfwq1).multiply(xs).add(bdj1);
                json.put("coccoiczfyzkl", zkl);
                json.put("czfy", czfy);
                json.put("czfypgfs", "客户档案成交报价");
                json.put("sfrgpg", "0");
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



