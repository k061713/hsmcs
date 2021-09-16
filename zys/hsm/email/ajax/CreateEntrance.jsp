<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinCaseType" %>
<%@ page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType" %>
<%@ page import="net.sourceforge.pinyin4j.PinyinHelper" %>
<%@ page import="net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="weaver.interfaces.workflow.action.hrm.MapComparator" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="org.codehaus.jettison.json.JSONException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%

	/**
	 *    创建邮箱 zys
	 */
	new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行创建263邮箱操作<<<<<<<<<");
	RecordSet rs = new RecordSet();
	RecordSet rs_ = new RecordSet();
	RecordSet rs_1 = new RecordSet();
	RecordSet rs_2 = new RecordSet();
	RecordSet rs_3 = new RecordSet();
	JSONObject jsonObject1 = new JSONObject();
	String xm = request.getParameter("xygxm");   //新员工姓名
	String ygbh = request.getParameter("ygbh");          //员工编号
	String[] sqbm = request.getParameterValues("sqbm");   //所属部门
	String lygw = request.getParameter("lygw");          //任用岗位
	new BaseBean().writeLog("新员工姓名:" + xm + " 员工编号:" + ygbh+ " 所属部门:" + sqbm+ " 任用岗位:" + lygw);
	JSONObject Json = new JSONObject();
	String url="http://macom.263.net/api/mail/v2/user/create";	//接口地址
	String tag = "1590051811688";		//唯一标识
	String account = "hqts.com";		//接口账号
	long ts = System.currentTimeMillis();//时间戳
	String domain = "hqts.com";			//邮箱的域名
	String xmuserid=ygbh;				//用户ID，最大长度为英文64（包含域名）字符
	//String xmname=xygxm;					//用户姓名
	String passwd = ygbh;				//邮箱密码
	String sql ="select * from hrmresource where loginid = '"+ygbh+"'";
	rs.execute(sql);
	String ygid="";
	String ssbm="";
	String ssjg="";

	while (rs.next()) {
		ygid= rs.getString("id");
		ssbm =rs.getString("departmentid");//所属部门
		ssjg =rs.getString("subcompanyid1");//所属机构
	}
	if (ygid!=""){
		String Aname = "";
		String sql_ ="select * from hrmresource where lastname = '"+xm+"'";//查询人员信息表中xm所有数据
		boolean a= rs_.execute(sql_);

		if(a) {//判断姓名是否相同
			Aname = cn2Spell(xm);
			boolean boola = HasDigit(Aname);
			if(boola) {
				String[] strs = Aname.split( "[^0-9]" ); //根据不是数字的字符拆分字符串
				String numStr = strs[strs.length- 1 ]; //取出最后一组数字
				int  n = numStr.length(); //取出字符串的长度
				int  num = Integer.parseInt(numStr)+ 1 ; //将该数字加一
				String added = String.valueOf(num);
				n = Math.min(n, added.length());
				//拼接字符串
				Aname = Aname.subSequence( 0 , Aname.length()-n)+added;
			}else {
				Aname = Aname+"1";
			}
		}else {
			Aname = cn2Spell(xm);
		}

		String pingyin1=Aname.replace(" ", "_");
		String gbkname= new String(pingyin1.getBytes(),"GBK");
		org.apache.commons.codec.binary.Base64 base64 = new Base64();
		String base64name = base64.encodeToString(gbkname.getBytes("UTF-8"));
		//int[] deptids= Arrays.asList(sqbm).stream().mapToInt(Integer::parseInt).toArray();				//所属部门id,如果用户有多个部门，则填写多条deptId记录。
		int deptids[]={0};
		//int roleid=Integer.parseInt(lygw);						//所属角色，角色ID，默认角色ID 为 0
		int roleid=0;
		int changepwd=0;					//首次登录是否修改密码，1为启用，0为禁用
		int mailstatus=1;					//邮箱状态，1为启用，0为禁用
		Json.put("domain", domain);
		Json.put("account", account);
		Json.put("tag", tag);
		Json.put("ts", ts);
		Json.put("xmuserid", xmuserid);
		Json.put("xmname", base64name);
		Json.put("deptids", deptids);
		Json.put("roleid", roleid);
		Json.put("changepwd", changepwd);
		Json.put("mailstatus", mailstatus);
		Json.put("passwd", encode(passwd));
		Getsign(Json);//字段排序
		//请求
		String result1 =  doPost(url, Json.toString());
		org.codehaus.jettison.json.JSONObject jsonObject = new org.codehaus.jettison.json.JSONObject(result1);
		String errcode = jsonObject.getString("errcode");//返回码， 0代表成功，其他代表失败
		String errmsg = jsonObject.getString("errmsg");//对返回码的文本描述内容
		if(errcode.equals("0")) {
			new BaseBean().writeLog("创建成功:"+errcode);
			String sql2 ="Insert into cus_fielddata (id,field23) VALUES ('"+ygid+"','"+passwd+"')";
			new BaseBean().writeLog("插入员工信息SQL:" + sql2);
			rs_2.execute(sql2);
			GetsUserInfo(ygbh,ygid,ssbm,ssjg);
			jsonObject1.put("code", 200);
			jsonObject1.put("msg","创建成功！");
		}else {
			new BaseBean().writeLog("插入失败，错误为："+errmsg);
			jsonObject1.put("code", 100);
			jsonObject1.put("msg",errmsg);
		}
	}else{
		jsonObject1.put("code", 101);
		jsonObject1.put("msg","创建失败，员工id为空");
	}
	out.clear();
	out.print(jsonObject1);
%>

<%!

	/**
	 *
	 *
	 * @throws UnsupportedEncodingException
	 * @throws IOException
	 */
	public void GetsUserInfo(String ygbh,String ygid,String ssbm,String ssjg){
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		JSONObject Json = new JSONObject();
		String url="http://macom.263.net/api/mail/v2/user/info";	//接口地址
		String tag = "1590051811688";		//唯一标识
		String account = "hqts.com";		//接口账号
		long ts = System.currentTimeMillis();//时间戳
		String domain = "hqts.com";			//邮箱的域名
		String xmuserid=ygbh;				//用户ID，最大长度为英文64（包含域名）字符
		Json.put("domain", domain);
		Json.put("account", account);
		Json.put("tag", tag);
		Json.put("ts", ts);
		Json.put("xmuserid", xmuserid);
		Getsign(Json);//字段排序
		//请求
		try {
			String result1 =  doPost(url, Json.toString());
			org.codehaus.jettison.json.JSONObject jsonObject = new org.codehaus.jettison.json.JSONObject(result1);
			System.out.println("结果："+jsonObject);//
			String errcode = jsonObject.getString("errcode");//返回码， 0代表成功，其他代表失败
			String errmsg = jsonObject.getString("errmsg");//对返回码的文本描述内容
			if(errcode.equals("0")) {
				System.out.println("获取成功:"+errcode);
				String jsonObject1 = jsonObject.getString("data");
				JSONArray mapJson = JSONArray.parseArray(jsonObject1);
				JSONArray jsonArray = new JSONArray();
				//FFCSJsonMap jsonStr = new FFCSJsonMap();
				for (int i = 0; i < mapJson.size(); i++) {//遍历
					JSONObject obj= new JSONObject();
					Map<String, String> mapResult = (Map<String, String>) mapJson.get(i);
					String emali=String.valueOf(mapResult.get("xmuserid"));//邮箱
					//String xmname=String.valueOf(mapResult.get("xmname"));//姓名
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date date1 = new Date();
					String modedatacreatedate=df.format(date1).substring(0,df.format(date1).indexOf(" "));
					String modedatacreatetime=df.format(date1).substring(df.format(date1).lastIndexOf(" ")+1);
					String uuid = UUID.randomUUID().toString();
					String sql = "update hrmresource set email='"+emali+"'"+" where loginid ='"+ygbh+"'";
					String sql1 ="Insert into uf_ryda (formmodeid,modedatacreatedate,modedatacreatetime,MODEUUID,szjg,szbm,gh,rymc,jsdzyx,dzyxmm) VALUES ('"+344+"','"+modedatacreatedate+"','"+modedatacreatetime+"','"+uuid+"','"+ssjg+"','"+ssbm+"','"+ygbh+"','"+ygid+"','"+emali+"','"+xmuserid+"')";
					rs.execute(sql);//更新人员信息表
					rs1.execute(sql1);//插入人员能力表
				}
			}else {
				new BaseBean().writeLog("获取失败，错误为："+errmsg);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}




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


	/**
	 * 判断一个字符串是否含有数字
	 * @param content
	 * @return
	 */
	public  boolean HasDigit(String content) {
		boolean flag = false;
		Pattern p = Pattern.compile(".*\\d+.*");
		Matcher m = p.matcher(content);
		if (m.matches()) {
			flag = true;
		}
		return flag;
	}


	/**
	 * 字段排序
	 * @param json
	 * @return
	 *
	 */
	public  String Getsign(JSONObject json) {
		//JSONObject Json1 = new JSONObject();
		Map<String,String> map = JSON.parseObject(json.toString(),Map.class);
		Map<String, String> resultMap = sortMap(map);
		String result = JSON.toJSONString(resultMap);
		String Token="j1m2s4";
		String a = result+Token;
		String sign="";
		try {
			sign = encode(a);
			json.put("sign", sign);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sign;
	}

	public  Map<String, String> sortMap(Map<String, String> map) {
		if (map == null || map.isEmpty()) {
			return null;
		}
		Map<String, String> sortMap = new TreeMap<String, String>(new MapComparator());
		sortMap.putAll(map);
		return sortMap;
	}
	/**
	 * md加密
	 * @param
	 * @return
	 *
	 */
	public static String encode(String string) throws Exception {
		StringBuilder stringBuilder = new StringBuilder();
		try {
			byte[] md5s = MessageDigest.getInstance("MD5").digest(string.getBytes("utf-8"));
			for (byte b : md5s) {
				stringBuilder.append(String.format("%02x", new Integer(b & 0xff)));
			}
			return stringBuilder.toString();
		} catch (Exception e) {
			throw new Exception("md5对象初始化失败", e);
		}
	}
	/**
	 *
	 * @param url
	 * @param param
	 * @return
	 */
	public  String doPost(String url, String param) {
		OutputStreamWriter out = null;
		BufferedReader in = null;
		String result = "";
		try {
			URL realUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
			// 打开和URL之间的连接

			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestMethod("POST");    // POST方法


			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

			conn.connect();

			// 获取URLConnection对象对应的输出流
			out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
			// 发送请求参数
			out.write(param);
			// flush输出流的缓冲
			out.flush();
			// 定义BufferedReader输入流来读取URL的响应
			in = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				result += line;
			}
		} catch (Exception e) {
			System.out.println("发送 POST 请求出现异常！"+e);
			e.printStackTrace();
		}
		//使用finally块来关闭输出流、输入流
		finally{
			try{
				if(out!=null){
					out.close();
				}
				if(in!=null){
					in.close();
				}
			}
			catch(IOException ex){
				ex.printStackTrace();
			}
		}
		return result;
	}
%>






