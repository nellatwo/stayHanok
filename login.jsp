<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  response.setContentType("text/html; charset=utf-8");
  response.setCharacterEncoding("utf-8");
  request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>로그인</title>
<style type="text/css"></style>
</head>

<script src="https://code.jquery.com/jquery-3.1.0.js"></script>
<script type="text/javascript" src="js/login.js"></script>

<link rel="stylesheet" href="css/login.css" type="text/css">


<body>
 <%
    String clientId = "KmjumL7UrW_5NtwhkmAc";//애플리케이션 클라이언트 아이디값";
    String redirectURI = URLEncoder.encode("http://localhost:8080/naverCallback", "UTF-8");
    SecureRandom random = new SecureRandom();
    String state = new BigInteger(130, random).toString();
    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
    apiURL += "&client_id=" + clientId;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&state=" + state;
    
    session.setAttribute("state", state);
 %>
 
  <!--헤더-->
  <jsp:include page="header.jsp"></jsp:include>

  <div class="wrap0">
    <section id="joinSection">
      <form name=login action="loginProcess.do" method="post">
        <table>
          <tr align="center">
            <td colspan="2">
              <h1>로그인</h1>
              <br>
            </td>
          </tr>
          <tr align="center">
            <td colspan="2">
              <div class="SNSSignUp">SNS계정으로 로그인하기</div>
              <div>
<%--               	<a href="<%=apiURL%>"><img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/></a>
 --%>          		
          		
          		 <a href="javascript:kakaoLogin();"><img width="130px" height="50px" src="images/icon/kakaoLoginBtn.png"/></a>
              </div>
            </td>
          </tr>
          
          <tr align="center">
              <td></td>
          </tr>
          
          <tr align="center">
              <td >
                  <hr />
              </td>
          </tr>
        
          <tr> 
	          <td colspan="2">
	          	  <div class="emailDiv">
	                  <div>
	                      <input type="text" name="email" placeholder="이메일" maxlength="20" size="40" class="text">
	             	  </div>
	              </div>
	          </td>
          </tr>
         
          <tr>
         	   <td colspan="2">
                	<input type="password" name="pw" placeholder="비밀번호" maxlength="16" size="40" class="text">
          	   </td>
          </tr>
		  
          <tr align="center">
              <td colspan="2">
                  <a href="signUp.do">
                      <input type="button" class="button" value="회원가입">
                  </a>
                  <input type="submit" class="button" value="로그인">
              </td>
          </tr>
        </table>
      </form>
      
      <form id="kakaoLoginForm" method="post" action="kakaoLogin.do">
         	 <input type="hidden" name="emailFromKakao" id=""/>
	 		 <input type="hidden" name="nicknameFromKakao"/>
	  </form>
     
    </section>
  </div>

  <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
  <script>
        window.Kakao.init('8b027d0e5ac703131c8868ab28f50316');

        function kakaoLogin() {
            window.Kakao.Auth.login({
                scope: 'profile_nickname, account_email', //동의항목 페이지에 있는 개인정보 보호 테이블의 활성화된 ID값을 넣습니다.
                success: function(response) {
                    console.log(response) // 로그인 성공하면 받아오는 데이터
                    window.Kakao.API.request({ // 사용자 정보 가져오기 
                        url: '/v2/user/me',
                        success: (response) => {
                            const kakao_account = response.kakao_account;
                           /*  alert(kakao_account) */
                           /*  alert(JSON.stringify(kakao_account)) */
                            getInfo();

                        }
                    });
                   /* window.location.href='/stayHanok/main.do' */
                   

                },
                fail: function(error) {
                    console.log(error);
                }
            });
        }
        
        function getInfo() {
            Kakao.API.request({
                url: '/v2/user/me',
                success: function (res) {
                    console.log(res);
                    // 이메일, 성별, 닉네임
                    var email = res.kakao_account.email;
                   /*  var gender = res.kakao_account.gender; */
                    var nickname = res.kakao_account.profile.nickname;
                    /* var profile_image = res.kakao_account.profile.thumbnail_image_url; */

                    $('input[name=emailFromKakao]').val(email);
                    $('input[name=nicknameFromKakao]').val(nickname);
 					document.querySelector('#kakaoLoginForm').submit();
 
                    console.log(email, nickname);
                },
                fail: function (error) {
                    alert('카카오 로그인에 실패했습니다. 관리자에게 문의하세요.');
                }
            });
        }
    </script>
  <!--풋터-->
</body>
</html>