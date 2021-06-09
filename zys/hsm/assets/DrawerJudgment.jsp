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
    /**     销售管理
     *      XS07客户转正流程-出票员判断接口
     *      zys
     *      20210407
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行出票员判断操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String hzjgzl = request.getParameter("hzjgzl");//合作机构类型
    String hzjg = request.getParameter("hzjg");//合作机构
    String ywgzjg = request.getParameter("ywgzjg");//业务归属机构
    String qzkhld = request.getParameter("qzkhld");//客户全称
    String sql="";
    boolean cnorEn=true;

    try {
        String num = "";
        String alph = "";

        boolean aa =!hzjgzl.equals("0")&&!hzjgzl.equals("");
        new BaseBean().writeLog("boolean:"+aa);
        if(aa){

            if(!hzjg.equals("")){

                char[]  arr =  hzjg.toCharArray();
                for(int i = 0; i < arr.length; i++){
                    try{
                        int a = Integer.parseInt(String.valueOf(arr[i]));
                        num = num.concat(String.valueOf(arr[i]));
                    }catch (Exception e){
                        alph = alph.concat(String.valueOf(arr[i]));
                    }
                }
            }
            if(hzjgzl.equals("1")){
                sql="select * from uf_jyjg where id="+num;//检验机构
            }else if(hzjgzl.equals("2")){
                sql="select * from uf_jcjg where id="+num;//检测机构
            }else if(hzjgzl.equals("3")){
                sql="select * from uf_rzjg where id="+num;//认证机构
            }else if(hzjgzl.equals("4")){
                sql="select * from uf_qtjg where id ="+num;//其他机构
            }
        }else {

            String sfyxsdl="";

            if(!hzjg.equals("")&&hzjg.equals("0")){
                 sfyxsdl="1";
            }else {
                 sfyxsdl="0";
            }

            String sfszm="";
            char c = qzkhld.charAt(0);
            cnorEn = isChinese(c);
            if(!cnorEn){
                cnorEn= isEnglish(qzkhld.substring(0,1));
            }
            new BaseBean().writeLog(">>>>>>>>>>>>>>全称类型<<<<<<<<<"+cnorEn);

            if(cnorEn){

                String  Aname = cn2Spell(qzkhld).substring(0,1);
                sql="select * from uf_cpyfpgz where ywgzjg="+ywgzjg+" and sfyxsdl="+sfyxsdl+" and szm like '%"+Aname+"%'";//
            }else {

                sfszm="1";
                sql="select * from uf_cpyfpgz where ywgzjg="+ywgzjg+" and sfyxsdl="+sfyxsdl+" and sfszm="+sfszm;
            }


        }


        String cpr="";//出票员

        new BaseBean().writeLog("当前执行的语句："+sql+",页面id："+workflowid);
        rs.execute(sql);

        while (rs.next()){

            if(!hzjgzl.equals("0")&&!hzjgzl.equals("")){

                cpr= rs.getString("cpr");
            }else {

                cpr= rs.getString("cpy");
            }

            json.put("cpr",cpr);
        }

        new BaseBean().writeLog("当前执行的结果："+json.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>

<%!
    public static boolean isChinese(char c) {

        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);

        if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS

                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS

                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A

                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION

                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION

                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {

            return true;

        }

        return false;

    }
    /**
     * 是否是英文
     * @param
     * @return
     */

    public static boolean isEnglish(String charaString){

        return charaString.matches("^[a-zA-Z]*");

    }
%>

<%!
    /**
     * 获取汉字串拼音，英文字符不变
     *
     * @param chinese 汉字串
     * @return 汉语拼音
     */

    public  String cn2Spell(String chinese) {
        StringBuffer pybf = new StringBuffer();
        char[] arr = chinese.toCharArray();
        HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
        defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
        defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] > 128) {
                try {
                    pybf.append(PinyinHelper.toHanyuPinyinStringArray(arr[i], defaultFormat)[0]);
                } catch (BadHanyuPinyinOutputFormatCombination e) {
                    e.printStackTrace();
                }
            } else {
                pybf.append(arr[i]);
            }
        }
        return pybf.toString();
    }

%>