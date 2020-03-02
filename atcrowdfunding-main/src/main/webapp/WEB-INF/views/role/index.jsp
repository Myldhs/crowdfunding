<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
	/* 设置超链接鼠标悬停显示为手 */
	a:hover{cursor:pointer}
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
				<form class="form-inline" role="form" style="float:left;">
				  <div class="form-group has-feedback">
				    <div class="input-group">
				      <div class="input-group-addon">查询条件</div>
				      <input class="form-control has-success" name="keyWord" type="text" placeholder="请输入查询条件">
				    </div>
				  </div>
				  <button type="button" class="btn btn-warning" id="btnSearch"><i class="glyphicon glyphicon-search"></i> 查询</button>
				</form>
				<sec:authorize access="hasRole('PM - 项目经理')">
					<button type="button" class="btn btn-danger" id="deleteBatch" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
				</sec:authorize>
				<button type="button" class="btn btn-primary" style="float:right;" id="btnSave"><i class="glyphicon glyphicon-plus"></i> 新增</button>
				<br>
		
 				  <hr style="clear:both;">
		          <div class="table-responsive">
		            <table class="table  table-bordered">
		              <thead>
		                <tr >
		                  <th width="30">#</th>
						  <th width="30"><input type="checkbox" id="checkAll"></th>
		                  <th>名称</th>
		                  <th width="100">操作</th>
		                </tr>
		              </thead>
		              <tbody id="tbody"><!--添加id为了js设置角色html  -->
		              
		              	<!-- 角色显示 -->
		              
		              </tbody>
		              
					  <tfoot>
					     
					     <tr >
		     				<td colspan="6" align="center">
								<ul class="pagination" id="pageUl"><!--添加id为了js设置分页html-->
										<!-- 分页信息 -->
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
    
    
	<!-- 添加的模态框 -->
	<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加</h4>
	      </div>
	      <div class="modal-body">
	      
	      	<!-- 模态框开始显示内容 -->
	        <form role="form" method="post" id="addForm">
			  <div class="form-group">
				<label for="exampleInputPassword1">角色名称</label>
				<input type="text" class="form-control" name="name" id="addInput" placeholder="请输入角色名称">
			  </div>
			</form>
	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="btnAdd">添加 </button>
	      </div>
	    </div>
	  </div>
	</div><!-- 添加模态框结束 -->

	<!-- 修改的模态框 -->
	<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改</h4>
	      </div>
	      <div class="modal-body">
	      
	      	<!-- 模态框开始显示内容 -->
	        <form role="form" method="post" id="updateForm">
			  <div class="form-group">
				<label for="exampleInputPassword1">角色名称</label>
				<input type="text" class="form-control" name="name" id="updateInput" placeholder="请输入角色名称">
			  </div>
			</form>
	        
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="btnUpdate">修改</button>
	      </div>
	    </div>
	  </div>
	</div><!-- 修改模态框结束 -->


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
            
            
            //使用ajax异步请求分页查询显示数据
            $(function(){
            	
            	//调用方法传入目标页码，页面首次加载默认显示第一页
            	loadData(1);
            	
            });
            
            //设计一个方法，由这个方法发出加载页面数据分页显示的请求
            var keyWord = "";//定义全局条件模糊查询关键字,任何地方都能使用，赋值就能用
            function loadData(pageNum){
            	
            	$.getJSON("${appPath}/role/loadData",{
            		"pageNum":pageNum,
            		"pageSize":2,
            		"keyWord":keyWord
            		
            	},function(res){
            		if(res=="403"){
            			layer.msg("您没有此访问权限!",{time:1000,icon:5});
            		}else{
	            		//接收回来信息后自动转换为一个json对象
	            		showRole(res.list);//展示角色信息res.list原来是结果集转化为JSON后为数组
	    				showPage(res);//展示分页导航
            		}
            	});
            }
            
          	//设计两个方法，一个方法用来处理显示角色，一个方法用来处理分页
          	function showRole(roleList){
          		
          		//定义变量用来拼接所有角色的html标签
          		var content ="";
          		//拼接角色项HTML信息，然后直接设置显示在页面上,roleList有多少对象就有多少项拼接在一起，每一次调用content都会被重置
          		for (var i = 0; i < roleList.length; i++) {
          			
          			content+='<tr>';
          			content+='<td>1</td>';
          			content+='<td><input type="checkbox" class="checks" id="'+(roleList[i].id)+'"></td>';
          			content+='<td>'+(roleList[i].name)+'</td>';
          			content+='<td>';
          			content+='<button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
          			content+='<button type="button" class="btn btn-primary btn-xs" id="update"><i class=" glyphicon glyphicon-pencil"></i></button>';
          			content+='<button type="button" class="btn btn-danger btn-xs" id="delete"><i class=" glyphicon glyphicon-remove"></i></button>';
          			content+='</td>';
          			content+='</tr>';
					
				}
          		//拼接完所有角色项的html后设置在页面显示
          		$("#tbody").html(content);
          	}
            
          	
          	//处理分页
          	function showPage(pageInfo){
          		
          		//定义变量用来拼接分页的html标签
          		var content ="";
          	
          		//判断是否为第一页,来拼接不同的html
          		if(pageInfo.isFirstPage){
          			content+='<li class="disabled"><a>上一页</a></li>';
          		}else{
          			content+='<li onclick="loadData('+(pageInfo.pageNum-1)+')"><a>上一页</a></li>';
          		}
          		
          		//分页逻辑
          		for (var i = 0; i < pageInfo.navigatepageNums.length; i++) {
					if(pageInfo.pageNum==pageInfo.navigatepageNums[i]){
						content+='<li class="active"><a onclick="loadData('+(pageInfo.navigatepageNums[i])+')">'+(pageInfo.navigatepageNums[i])+' <span class="sr-only">(current)</span></a></li>';
					}else{
						content+='<li><a onclick="loadData('+(pageInfo.navigatepageNums[i])+')">'+(pageInfo.navigatepageNums[i])+'</a></li>';
					}
					
				}
          	
          		//判断是否为第最后一页,来拼接不同的html
          		if(pageInfo.isLastPage){
          			content+='<li class="disabled"><a>下一页</a></li>';
          		}else{
          			content+='<li onclick="loadData('+(pageInfo.pageNum+1)+')"><a>下一页</a></li>';
          		}
          		
          		//设置显示HTML
          		$("#pageUl").html(content);
          	}
          	
          	//btnSearch 带条件查询点击查询的单击事件
          	$("#btnSearch").click(function(){
          		
          		//alert("aaa");
          		//为KeyWord赋值，然后调用查询方法，就能实现带条件查询
          		keyWord=$("input[name='keyWord']").val();//获取文本框的值使用val()
          		//alert(keyWord);
          		loadData(1);
          	});
          	
          	
          	//btnSave 点击新增跳出显示模态框
          	$("#btnSave").click(function(){
          		
          		//设置多个参数时以json的行式设置
          		$('#addModal').modal(
          			{
 						 show:true,//模态框初始化之后就立即显示出来。
 						 backdrop:false,//不会在点击到模态框以外的地方后，关闭模态框
 						/*  backdrop:"static", */
 						 keyboard:false//键盘上的 esc 键被按下时不关闭模态框
   					}	
          		)
          	});
          	
          	//点击添加后的单击事件
          	$("#btnAdd").click(function(){	
          		
          		//获取添加的参数值
          		var roleName= $("input[name='name']").val();
          		
          		//请求后台添加角色
          		$.post("${appPath}/role/save?name="+roleName,function(res){
          			
          			//对响应结果进行判断，看添加是否成功
          			if(res=="yes"){
          				 layer.msg("添加成功!",{time:1000,icon:6},function(){
          					 //自动关闭模态框
				    		 $('#addModal').modal("hide");
          					 //添加后再次查询，显示添加信息
				    		 loadData(1);
				    	 })
          				
          			}else{
          				layer.msg("添加失败!",{time:1000,icon:5},function(){
         					 //自动关闭模态框
				    		 $('#addModal').modal("hide");
				    	 })
          			}
            	});
          	});
          	
          	
          	//点击修改跳出模态框     在#tbody里面的id为#update的加上点击事件
          	$("#tbody").on("click","#update",function(){
          	//$("#update").on("click",function(){
          		
          		//获取修改角色的id
          		var id = $(this).parent().prev().prev().find("input").prop("id");
          		
          		//获取修改项的信息用于回显
          		var text =$(this).parent().prev().text(); 
          		//回显修改的角色信息
          		$("#updateInput").val(text);
          		
          		//调用模态框
          		$('#updateModal').modal(
              			{
     						 show:true,//模态框初始化之后就立即显示出来。
     						 backdrop:false,//不会在点击到模态框以外的地方后，关闭模态框
     						 keyboard:false//键盘上的 esc 键被按下时不关闭模态框
       					}	
              		)
              		
              		//点击模态框里的修改后的单击事件   btnUpdate
                  	$("#btnUpdate").click(function(){	
                  	//$("#update").on("click",function(){
                  		//获取修改的参数值
                  		var roleName= $("#updateInput").val();
                  		
                  		//请求后台修改角色
                  		$.post("${appPath}/role/update?name="+roleName+"&id="+id,function(res){
                  			
                  			//对响应结果进行判断，看修改是否成功
                  			if(res=="yes"){
                  				 layer.msg("修改成功!",{time:1000,icon:6},function(){
                  					 //自动关闭模态框
        				    		 $('#updateModal').modal("hide");
                  					 //修改后再次查询，显示添加信息
        				    		 loadData(1);
        				    	 })
                  				
                  			}else{
                  				layer.msg("修改失败!",{time:1000,icon:5},function(){
                 					 //自动关闭模态框
        				    		 $('#updateModal').modal("hide");
        				    	 })
                  			}
                    	});
                  });
          	});
          	
          
          	//实现单行删除
          	$("#tbody").on("click","#delete",function(){
          		
          		//alert("aaa");
          		//获取删除角色的id
          		var id = $(this).parent().prev().prev().find("input").prop("id");
          		
          		//请求后台删除角色
          		$.post("${appPath}/role/delete?id="+id,function(res){
          			
          			//对响应结果进行判断，看删除是否成功
          			if(res=="yes"){
          				 layer.msg("删除成功!",{time:1000,icon:6},function(){
          					 //删除后再次查询，显示最新信息
				    		 loadData(1);
				    	 })
          				
          			}else{
          				layer.msg("删除失败!",{time:1000,icon:5})
          			}
            	});
          		
          	});
          	
          	//jQuery获取元素为了给元素加上点击事件而获取跟为了拿到元素本身或者为了拿到元素的属性值而获取是不一样的
          	//前者受到页面代码是否是动态生成的影响，后者则不受其影响
          	
          	
          	//批量删除
           	//点击checkAll全选当前页的所有行
           	var $checkAll= $("#checkAll");
          	
           	$checkAll.click(function(){
           		//使用jQuery过滤选择器，选择所有单选框
           		//这个获得结果是一个数组，里面都是单选框的dom对象
           		//var $checks=$("#tbody").find("tr").find("td").find("input");
           		
           		var $checks=$(".checks");
           		
           		//$checks遍历数组，index当前项的下标，checkBox遍历的当前项
           		$.each($checks,function(index,checkBox){
           			
           			//将每一行的单选按钮设置为与checkAll的选中状态相同
           			checkBox.checked=$checkAll[0].checked;
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
	      	  			
			      	  			//请求后台删除角色
			              		$.post("${appPath}/role/deleteBatch?ids="+ids,function(res){
			              			
			              			//对响应结果进行判断，看删除是否成功
			              			if(res=="yes"){
			              				 layer.msg("删除成功!",{time:1000,icon:6},function(){
			              					 //删除后再次查询，显示添加信息
			    				    		 loadData(1);
			    				    	 })
			              				
			              			}else{
			              				layer.msg("删除失败!",{time:1000,icon:5})
			              			}
			                	});
	    	    		  	 	//location.href="${appPath}/role/deleteBatch?ids="+ids;//在java中的表示 "3,16"字符串
	    	    		  	 	//删除后再次查询，显示最新信息
	    	    		  	 	loadData(1);
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
