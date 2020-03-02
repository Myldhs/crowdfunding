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

	<!-- 页面被抽取静态包含 -->
    <%@ include file="/WEB-INF/common/css.jsp" %>
	<link rel="stylesheet" href="css/doc.min.css">
	
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	</style>
  </head>

  <body>

    <!--动态包含抽取的上面标题栏  -->
   	<jsp:include page="/WEB-INF/common/nav.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
      
        <!--动态包含抽取的侧边栏  -->
        <jsp:include page="/WEB-INF/common/side-bar.jsp"></jsp:include>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<ol class="breadcrumb">
				  <li><a href="#">首页</a></li>
				  <li><a href="#">数据列表</a></li>
				  <li class="active">修改</li>
				</ol>
			<div class="panel panel-default">
              <div class="panel-heading">表单数据<div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
			  <div class="panel-body">
			  
				<form role="form" action="${appPath}/admin/update" method="post" id="updateForm">
					<!-- 修改信息提交时原来的id是不变的，应该还带上 -->
					<input type="hidden" name="id" value="${admin.id}">
					<!-- 实现修改完毕后跳转到原信息所在页，便于查看，所以它的所在页数也要随着请求，再响应回来（从index.jsp发出请求带着页数再经后台响应回来获取） -->
				    <input type="hidden" name="pageNum" value="${param.pageNum}">
				
				  <div class="form-group">
					<label for="exampleInputPassword1">登陆账号</label>
					<input type="text" class="form-control" name="loginacct" value="${admin.loginacct}" id="exampleInputPassword1" placeholder="请输入登陆账号">
				  </div>
				  <div class="form-group">
					<label for="exampleInputPassword1">用户名称</label>
					<input type="text" class="form-control" name="username" value="${admin.username}" id="exampleInputPassword1" placeholder="请输入用户名称">
				  </div>
				  <div class="form-group">
					<label for="exampleInputEmail1">邮箱地址</label>
					<input type="email" class="form-control" name="email" value="${admin.email}" id="exampleInputEmail1" placeholder="请输入邮箱地址">
					<p class="help-block label label-warning">请输入合法的邮箱地址, 格式为： xxxx@xxxx.com</p>
				  </div>
				  <button type="button" class="btn btn-success" onclick="$('#updateForm').submit()"><i class="glyphicon glyphicon-plus"></i>修改</button>
				  <button type="button" class="btn btn-danger"><i class="glyphicon glyphicon-refresh"></i> 重置</button>
				</form>
				
			  </div>
			</div>
        </div>
      </div>
    </div>
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
			<h4 class="modal-title" id="myModalLabel">帮助</h4>
		  </div>
		  <div class="modal-body">
			<div class="bs-callout bs-callout-info">
				<h4>测试标题1</h4>
				<p>测试内容1，测试内容1，测试内容1，测试内容1，测试内容1，测试内容1</p>
			  </div>
			<div class="bs-callout bs-callout-info">
				<h4>测试标题2</h4>
				<p>测试内容2，测试内容2，测试内容2，测试内容2，测试内容2，测试内容2</p>
			  </div>
		  </div>
		  <!--
		  <div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-primary">Save changes</button>
		  </div>
		  -->
		</div>
	  </div>
	</div>
    
    <!-- 动态引入抽取的js -->
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
