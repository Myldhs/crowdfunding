<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!--抽取的侧边栏  -->
<div class="col-sm-3 col-md-2 sidebar">
	<div class="tree">
		<ul style="padding-left:0px;" class="list-group">
			
			<!--根据数据库中的t_menu表动态显示菜单栏   父节点 子节点  -->
			<c:forEach items="${parentMenus}" var="menu">
				<!-- 没有子节点的父节点 -->
				<c:if test="${menu.childMenus.size()==0}">
					<li class="list-group-item tree-closed" >
						<a href="${appPath}/${menu.url}"><i class="${menu.icon}"></i>${menu.name}</a> 
					</li>
				</c:if>
				
				<!--有子节点的父节点  -->
				<c:if test="${menu.childMenus.size()!=0}">
					<li class="list-group-item tree-closed">
						<span><i class="${menu.icon}"></i> ${menu.name} <span class="badge" style="float:right">${menu.childMenus.size()}</span></span> 
						<ul style="margin-top:10px;display:none;">
							
							<!-- 子节点 -->
							<c:forEach items="${menu.childMenus}" var="child">
								<li style="height: 30px;"><a href="${appPath}/${child.url}"><i class="${child.icon}"></i> ${child.name}</a></li>
	                        </c:forEach>
							
							
						</ul>
					</li>
				</c:if>
			</c:forEach>
		</ul>
	</div>
</div>
     

     
     