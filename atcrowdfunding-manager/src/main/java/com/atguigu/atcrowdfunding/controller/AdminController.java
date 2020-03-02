package com.atguigu.atcrowdfunding.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class AdminController {
	
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private MenuService menuService;
	
	//刷新登录后页面避免重复登录，main页面里动态显示侧边栏
	@RequestMapping(value="/admin/main")
	public String main(HttpSession session) {
		
		//获取所有带有自己子节点的父节点集合
		List<TMenu> parentMenus = menuService.listAllMenu();
		//System.out.println(parentMenus);
		//将父节点集合送到前台页面上
		session.setAttribute("parentMenus", parentMenus);
		return "main";
		
	}
/*	
	//登录功能的控制器方法
	@RequestMapping(value="/login")
	public String login(String loginacct ,String userpswd ,HttpSession session) {
		
		//获取查询结果
		TAdmin adminLogin = adminService.getAdminLogin(loginacct, userpswd);
		
		//判断是否登录成功
		if(adminLogin==null) {
			session.setAttribute("error", "账号或密码错误！");
			return "login";
		}else {
			session.setAttribute("adminLogin", adminLogin);
			return "redirect:/admin/main";
		}
	}*/
	
	/*//退出登录的控制器方法
	@RequestMapping(value="/loginout")
	public String loginout(HttpSession session) {
		if(session!=null){
			//手动设置session失效
			session.invalidate();
			
		}
		return "forward:/WEB-INF/views/login.jsp";
	}*/
	
	/**
	 * 查询用户信息,查询结束后跳转到/admin/index页面,显示这个页面需要三个参数，前两个是分页所需后一个是查询条件
	 * pageNum 当前的页码
	 * pageSize 每页显示的行数
	 * keyWord 搜索条件(名称或者账号或者邮箱)
	 * @return
	 */
	//执行方法前对权限进行判断，具有权限后才能访问
	@PreAuthorize("hasRole('GL - 组长') AND hasAuthority('user:get')")
	@RequestMapping("/admin/index")
	public String index(
			@RequestParam(value="pageNum",required=false,defaultValue="1")Integer pageNum,
			@RequestParam(value="pageSize",required=false,defaultValue="2")Integer pageSize,
			@RequestParam(value="keyWord",required=false,defaultValue="")String keyWord,
			Model model
			) {
		//使用分页插件
		PageHelper.startPage(pageNum, pageSize);
		
		//开始查询
		List<TAdmin> listAdmin = adminService.listAdminPage(keyWord);
		
		//获取分页的详细信息
	    PageInfo<TAdmin> pageInfo=new PageInfo<>(listAdmin, 5);
		model.addAttribute("pageInfo", pageInfo);
		return "/admin/index";
	}
	
	/**
	 * 跳转到添加页面
	 */
	@RequestMapping("/admin/toAdd")
	public String toAdd() {
		
		return "admin/add";
		
	}
	/**
	 * 执行添加操作的控制器
	 */
	@RequestMapping("/admin/add")
	public String add(TAdmin admin) {
		
		adminService.saveAdmin(admin);
		
		//加上?pageNum="+Integer.MAX_VALUE; 有了分页合理化插件之后，能够自动判断，若目标页大于实际最大页则显示实际最大页,其目的是要那个数
		return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE;
	}
	
	/**
	 * 跳转到修改页面
	 */
	@RequestMapping("/admin/toupdate")
	public String toupdate(Integer id, Model model) {
		
		//获取修改的用户对象
		TAdmin admin = adminService.getAdminById(id);
		//将修改的用户对象传到前台，用于修改数据回显
		model.addAttribute("admin", admin);
		
		return "admin/update";
		
	}
	
	/**
	 * 执行修改操作控制器
	 */
	@RequestMapping("/admin/update")
	public String update(TAdmin admin,Integer pageNum) {
		
		adminService.updateAdminById(admin);
		return "redirect:/admin/index?pageNum="+pageNum;
	}
	
	/**
	 * 执行单行删除控制器
	 */
	@RequestMapping("/admin/delete")
	public String delete(Integer id,Integer pageNum) {
		
		adminService.deleteAdminById(id);
		
		//删除后跳回原来页面
		return "redirect:/admin/index?pageNum="+pageNum;
		
	}
		
	/**
	 * 执行批量删除控制器
	 */
	@RequestMapping("/admin/deleteBatch")
	public String deleteBatch(String ids) {
		  //拆分字符串
		 /*  String[] idStr = ids.split(",");
		    for (String id : idStr) {
			 Integer idInt=	Integer.parseInt(id);
		    	
			 adminService.delete(idInt);
			}
		*/
		
		//存放删除行id的数组
		List<Integer> idsList=new ArrayList<Integer>();
		
		String[] idStr = ids.split(",");
	    for (String id : idStr) {
	    	//得到Integer的删除行的id
	    	Integer idInt=	Integer.parseInt(id);
	    	//往数组中添加id
	    	idsList.add(idInt);
	    	
	    }
		
		adminService.deleteBatch(idsList);
		
		//删除后跳回原来页面
		return "redirect:/admin/index";
		
	}
	
	
	
	
	
	
}
