package com.atguigu.atcrowdfunding.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


@Controller
public class RoleController {
	
	@Autowired
	private RoleService roleService;
	
	
	/*
	 * 跳转到用户首页控制器
	 * */
	@RequestMapping(value="/role/index")
	public String index() {
		
		//使用同步请求返回页面
		return "/role/index";
	}
	/*
	 * 处理角色首页数据加载异步请求控制器
	 * */
	@ResponseBody
	@PreAuthorize("hasRole('PM - 项目经理')")//执行方法前对权限进行判断，具有权限后才能访问
	@RequestMapping(value="/role/loadData")
	public PageInfo<TRole> loadData(
				@RequestParam(value="pageNum",required=false,defaultValue="1") Integer pageNum,
				@RequestParam(value="pageSize",required=false,defaultValue="2") Integer pageSize,
				@RequestParam(value="keyWord",required=false,defaultValue="") String keyWord
			) {
		//查询前使用分页
		System.out.println(keyWord);
		PageHelper.startPage(pageNum, pageSize);
		List<TRole> listRole = roleService.listRolePage(keyWord);
		
		//封装详细查询信息
		PageInfo<TRole> pageInfo = new PageInfo<TRole>(listRole, 5);
		return pageInfo;
	}
	/*
	 * 添加角色异步请求控制器
	 * 没使用json也要加上@ResponseBody代表是异步响应的动作
	 * 前台异步请求后台异步响应
	 * */
	@ResponseBody
	@RequestMapping(value="/role/save")
	public String save(TRole role){
		
		//如果成功row为受影响的行数
		Integer row = roleService.saveRole(role);
		if(row==1) {
			return "yes";
		}
		return "no";
	}
	
	/*
	 * 修改角色异步请求控制器
	 * 暂时不考虑回到修改页
	 * */
	@ResponseBody
	@RequestMapping(value="/role/update")
	public String update(TRole role){
		
		//如果修改成功row为受影响的行数
		Integer row = roleService.updateRole(role);
		if(row==1) {
			return "yes";
		}
		return "no";
	}
	
	/**
	 * 角色单行删除控制器
	 * 暂时不考虑回到修改页
	 */
	@ResponseBody
	@RequestMapping("/role/delete")
	public String delete(Integer id) {
		
		//如果修改成功row为受影响的行数
		Integer row = roleService.deleteRole(id);
		if(row>0) {
			return "yes";
		}
		return "no";
		
	}
	
	
	/**
	 * 角色批量删除控制器
	 * 暂时不考虑回到修改页
	 */
	@ResponseBody
	@RequestMapping("/role/deleteBatch")
	public String deleteBatch(String ids) {
		  //拆分字符串
		 /*  String[] idStr = ids.split(",");
		    for (String id : idStr) {
			 Integer idInt=	Integer.parseInt(id);
		    	
			 adminService.delete(idInt);
			}
		*/
		
		//存放删除行id的集合
		List<Integer> idsList=new ArrayList<Integer>();
		
		String[] idStr = ids.split(",");
	    for (String id : idStr) {
	    	//得到Integer的删除行的id
	    	Integer idInt=	Integer.parseInt(id);
	    	//往数组中添加id
	    	idsList.add(idInt);
	    	
	    }
		
		//如果修改成功row为受影响的行数
		Integer row = roleService.deleteBatch(idsList);
		if(row>0) {
			return "yes";
		}
		return "no";
	}
}















