<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="weaver.interfaces.workflow.action.hrm.MapComparator" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.HttpURLConnection" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%

        /**
         *    删除用户邮箱 zys
         */

	RecordSet rs = new RecordSet();
	String ygbh = request.getParameter("ygbh");          //员工编号
	new BaseBean().writeLog(" 员工编号:" + ygbh);
	JSONObject Json = new JSONObject();
	String url="http://macom.263.net/api/mail/v2/user/delete";	//接口地址
	String tag = "1590051811688";		//唯一标识
	String account = "hqts.com";		//接口账号
	long ts = System.currentTimeMillis();//时间戳
	String domain = "hqts.com";			//邮箱的域名
	Json.put("domain", domain);
	Json.put("account", account);
	Json.put("tag", tag);
	Json.put("ts", ts);
	Json.put("xmuserid", ygbh);
	Getsign(Json);//字段排序
	//请求
	String result1 =  doPost(url, Json.toString());
	org.codehaus.jettison.json.JSONObject jsonObject = new org.codehaus.jettison.json.JSONObject(result1);
	String errcode = jsonObject.getString("errcode");//返回码， 0代表成功，其他代表失败
	String errmsg = jsonObject.getString("errmsg");//对返回码的文本描述内容
	if(errcode.equals("0")) {
		new BaseBean().writeLog("用户"+ygbh+"删除成功！");

	}else {
		new BaseBean().writeLog("删除失败，错误为："+errmsg);

	}
	out.clear();

%>

<%!



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
			new BaseBean().writeLog("发送 POST 请求出现异常！"+e);
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






