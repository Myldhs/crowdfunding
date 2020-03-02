<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
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
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
<form id="queryform" class="form-inline" role="form" style="float:left;" action="${appPath}/admin/index" method="post">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <!-- 请求转发时会把获得的请求参数也一起转发出去，在转发页面可通过param.keyWord获取 -->
      <input class="form-control has-success" type="text" name="keyWord" value="${param.keyWord}" placeholder="请输入查询条件">
    </div>
  </div>
  <button type="button" class="btn btn-warning" onclick="$('#queryform').submit()" ><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<sec:authorize access="hasRole('PM - 项目经理')">
	<button type="button" class="btn btn-danger" id="deleteBatch" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
</sec:authorize><button type="button" class="btn btn-primary" style="float:right;" onclick="location.href='${appPath}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr >
                  <th width="30">#</th>
                  
                  <!-- checkbox总的单选框,点击这个全选当前页 -->
				  <th width="30"><input type="checkbox" id="checkAll"></th>
                  <th>账号</th>
                  <th>名称</th>
                  <th>邮箱地址</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
              	<!-- 封装详细分页信息的pageInfo对象中有个list是查询的结果集 -->
              	<c:forEach items="${pageInfo.list}" var="admin">
	                <tr>
	                
	                  <td>1</td>
	                  
	                  <!-- 用户数据的当前行单选框，设置id属性为当前行的id,便于获取要删除的行id -->
					  <td><input type="checkbox" class="checks" id="${admin.id}"></td>
	                  <td>${admin.loginacct}</td>
	                  <td>${admin.username}</td>
	                  <td>${admin.email}</td>
	                  <td>
					      <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
					      <button type="button" class="btn btn-primary btn-xs"><i onclick="location.href='${appPath}/admin/toupdate?pageNum=${pageInfo.pageNum}&id=${admin.id}'" class=" glyphicon glyphicon-pencil"></i></button>
						  <button type="button" class="btn btn-danger btn-xs"><i  onclick="location.href='${appPath}/admin/delete?pageNum=${pageInfo.pageNum}&id=${admin.id}'"class=" glyphicon glyphicon-remove"></i></button>
					  </td>
					  
	                </tr>
              	</c:forEach>
              </tbody>
              
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination">
						
							<c:if test="${pageInfo.isFirstPage}">
								<!-- 是第一页 -->
								<li class="disabled" ><a href="#">上一页</a></li>
							</c:if>
							<c:if test="${not pageInfo.isFirstPage}">
								<!-- 不是第一页 -->
								<li><a href="${appPath}/admin/index?pageNum=${pageInfo.pageNum-1}&keyWord=${param.keyWord}">上一页</a></li>
							</c:if>

							<!--处理分页逻辑  pageInfo中的navigatepageNums数组保存了当前页的分页逻辑 应该显示的页码数字-->
							<c:forEach items="${pageInfo.navigatepageNums}" var="i">
								<c:if test="${i==pageInfo.pageNum}">
									<!-- 当前选中行高亮显示 active为高亮显示-->
									<li class="active"><a href="${appPath}/admin/index?pageNum=${i}&keyWord=${param.keyWord}">${i} <span class="sr-only">(current)</span></a></li>
								</c:if>
								<c:if test="${i!=pageInfo.pageNum}">
									<!-- 不是当前页 -->
									<li><a href="${appPath}/admin/index?pageNum=${i}&keyWord=${param.keyWord}">${i}</a></li>
								</c:if>
							</c:forEach>
							
							
							
							<c:if test="${pageInfo.isLastPage}">
								<!-- 是最后一页 -->
								<li class="disabled" ><a href="#">下一页</a></li>
							</c:if>
							<c:if test="${not pageInfo.isLastPage}">
								<!-- 不是最后一页 -->
								<li><a href="${appPath}/admin/index?pageNum=${pageInfo.pageNum+1}&keyWord=${param.keyWord}">下一页</a></li>
							</c:if>
							
						</ul>
					 </td>
				 </tr>

			  </tfoot>
            </table>
          </div>
			  </div>
			</div>
        </div>
      </div>
    </div>

    <!-- 动态引入抽取的js -->
	<jsp:include page="/WEB-INF/common/js.jsp"></jsp:include>
	<script type="text/javascript" src="${appPath}/static/layer/layer.js"></script>
	
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
            
            //删除多行
            
            $(function () {
            	
            	//点击checkAll全选当前页的所有行
            	var $checkAll= $("#checkAll");
            	$checkAll.click(function(){
            		//alert("aaa");
            		//使用jQuery过滤选择器，选择所有单选框
            		var $checks=$(".checks");//这个获得结果是一个数组，里面都是单选框的dom对象
            		//$checks遍历数组，index当前项的下标，checkBox遍历的当前项
            		$.each($checks,function(index,checkBox){
            			
            			//将每一行的单选按钮设置为与checkAll的选中状态相同
            			checkBox.checked=$checkAll[0].checked;
            		});
            	});
            });
            
          	//使用jQuery过滤选择器，获取所有被选中的单选框所在行，将所有的选中行的id数据发送到后台
      	  	$("#deleteBatch").click(function(){
      	  		
      	  		//选择被选中要删除的行  结果是个数组
            	var $checkedtrs= $(".checks:checked");
      	  		if($checkedtrs.length==0){
      	  			
      	  			//layer弹层插件     弹出信息  time显示时间    icon显示的图标，shift显示特效
      	  			layer.msg("你没有选中任何的行数据!!",{time:2000,icon:5,shift:6});
      	  		}else{
      	  			
      	  			//创建数组保存被选中的行的id信息
      	  			var ids =new Array();
      	  			
		     	  	$.each($checkedtrs,function(index,checkBox){
		       			//获取每一行的id属性值，然后放入数组中
		     	  		ids.push(checkBox.id);//集合中的add方法 [3,16]
		       		});
		     	  	
		     	 	//layer中的选择弹窗，"是否要删除?"显示的文本信息  后面是图标 按钮 每个按钮的回调函数，回掉函数的匹配是按照按钮顺序来的
	      	  		layer.confirm("是否要删除?",{icon:3,btn:["确定","取消"]},
	    	    			function(index){
	    	    		  	 	location.href="${appPath}/admin/deleteBatch?ids="+ids;//在java中的表示 "3,16"字符串
	    	    		   		layer.close(index);
	    	    	   },
	    	    			function(index){
	    	    		        layer.alert("取消");
	    	    		        layer.close(index);
	    	    	   });
      	  		}
      	  		
            });
      	
            
            
        </script>
  </body>
</html>














