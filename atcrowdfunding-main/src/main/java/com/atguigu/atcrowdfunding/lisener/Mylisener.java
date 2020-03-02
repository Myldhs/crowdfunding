package com.atguigu.atcrowdfunding.lisener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
/**
 * ServletContextListener监听器服务器启动创建ServletContext时执行这些方法
 * 获取项目绝对路径然后放进ServletContext域中使所有页面都能访问到获取项目绝对路径
 * @author Shinelon
 *
 */
public class Mylisener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		//ServletContextEvent sce ServletContextEvent事件对象里面封装了ServletContext对象
		ServletContext servletContext = sce.getServletContext();
		//获取项目绝对路径
		String contextPath = servletContext.getContextPath();
		//将项目绝对路径存放到servletContext域中
		servletContext.setAttribute("appPath", contextPath);

	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	}

}
