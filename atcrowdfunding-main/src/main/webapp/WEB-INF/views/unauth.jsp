<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
          <!-- 引入公共的样式  使用静态包含的方式  	将两个页面合并一个页面,编译生成一个类;-->
          <%@ include file="/WEB-INF/common/css.jsp" %>
          <!-- 动态包含  	生成多个类-->
         <%--  <jsp:include page="/WEB-INF/common/css.jsp"></jsp:include> --%>
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	.tree-closed {
	    height : 40px;
	}
	.tree-expanded {
	    height : auto;
	}
	</style>
  </head>

  <body>
    <jsp:include page="/WEB-INF/common/nav.jsp"></jsp:include>
    <div class="container-fluid">
      <div class="row">
        <jsp:include page="/WEB-INF/common/side-bar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">控制面板</h1>
             <h1>您没有权限访问该功能!!</h1>
          
        </div>
      </div>
    </div>
     <jsp:include page="/WEB-INF/common/js.jsp"></jsp:include>
        <script type="text/javascript">
            $(function () {
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
            });
        </script>
  </body>
</html>
