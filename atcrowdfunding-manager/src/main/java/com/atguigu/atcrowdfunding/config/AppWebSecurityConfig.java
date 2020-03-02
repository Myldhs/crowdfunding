package com.atguigu.atcrowdfunding.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;


@Configuration //spring框架的注解，配置注解，并且是组合注解，
@EnableWebSecurity //启用web安全框架    有了配置类有了这些注解就可以安全框架就可以起作用了
@EnableGlobalMethodSecurity(prePostEnabled = true) //开启全局方法级细粒度安全控制
public class AppWebSecurityConfig extends WebSecurityConfigurerAdapter{
	
		@Autowired
		private UserDetailsService userDetailsService;
		
		//试验4 认证  Authentication认证   认证是获取到前台登录请求后验证此用户是否是合法的是否可以登录系统
		@Override  //auth  认证管理对象  可用这个对象调一些方法进行对用户的验证
		protected void configure(AuthenticationManagerBuilder auth) throws Exception {
			
			//自定义用户认证  去数据库中查找用户信息                                                   使用自定义的密码加密器    自己创建实现类
			auth.userDetailsService(userDetailsService).passwordEncoder( new BCryptPasswordEncoder());
			
		}
	
		//试验1  授权功能  authorize 授权  
		@Override  //http  HTTP请求的安全对象  所有的授权资源访问都由这个对象进行访问
		protected void configure(HttpSecurity http) throws Exception {
			
			//super.configure(http);  父类中的该方法默认拦截所有的资源，所有请求都要进行验证   所有的请求都要验证通过后才能访问
			//服务器中存在的资源但是没有授权     403 Access Denied  访问受限
			// 404 服务器中没有该资源
			//设置对特定的资源放行(登录页面,静态资源)  permitAll 允许所有 即放行    authorize 授权  authenticated认证
			//授权请求  通配符匹配  允许所有的   其他请求  认证     授权请求请求通配符匹配的所有资源时通过，其他的请求则需要验证通过后才能访问
			http.authorizeRequests().antMatchers("/welcome.jsp","/static/**").permitAll()
															.anyRequest().authenticated();
			
			
			 //试验2
			 // http.formLogin();//默认跳转到springsecurity提供的登录页
			 //自定义表单登录页面  直接访问时会进入登录页面
			http.formLogin().loginPage("/welcome.jsp");
			
			
			//试验3 用框架实现表单登录  表单登录
			//处理登录的控制器地址，安全框架中有处理登录 的控制器，请求的映射地址是/login，如果前台登录表单提交地址就是/login，则后台不用做任何设置，若不是/login,
							//可用loginProcessingUrl()方法设置，此方法意思将请求URL为/login的请求提交到安全框架处理登录控制器						
			http.formLogin().loginProcessingUrl("/login")//本不用在设置这里设置是更加保险
		                   .usernameParameter("loginacct")// 设置参数为username   和登录页中的名字一致 获取名字   
		                   .passwordParameter("userpswd")// 设置参数为password 和登录页中的密码一致 获取密码
		                   .defaultSuccessUrl("/admin/main");//默认登录成功之后访问的控制器方法 ，此控制器一般跳转到主页
			
			
			//禁用csrf 不使用csrf跨站请求伪造令牌
			http.csrf().disable();  //超链接请求无法改为post csrf先暂时关闭
			
			
			//试验5  框架实现退出登录    logoutUrl() 
			//设置将请求URL为/logout的(前台退出登录请求的url是什么这就写什么)再提交给框架执行退出的控制器    logoutSuccessUrl 退出成功之后跳转到的页面
			http.logout().logoutUrl("/logout").logoutSuccessUrl("/welcome.jsp");
			
			
			//试验7  设置无访问权限时显示的页面   unauth  请求URL映射的控制器
			//http.exceptionHandling().accessDeniedPage("/unauth");
			//自定义无权限访问的跳转页面      接口的内部类        不走控制器了直接跳转
			http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
				@Override
				public void handle(HttpServletRequest request, HttpServletResponse response,
						AccessDeniedException accessDeniedException) throws IOException, ServletException {
					//accessDeniedException 是无访问权限的异常对象，里面封装了异常信息
					
					//我们前台写的请求类型有两种，没有权限的请求会执行到这里，这里就要对不同类型的请求做一个分别处理，不然异步的无权限访问请求将没有页面显示
					//根据同步请求与异步请求的请求头信息不同进行区分   对异步请求设置异步响应   直接向页面输出信息 就是响应了异步请球  
					//然后再在主页上异步请求发起处 对这返回信息做下处理 
					if("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
						response.getWriter().write("403");
					}else {
						
						request.setAttribute("msg", accessDeniedException.getMessage());
						//请求转发到页面     
						request.getRequestDispatcher("/WEB-INF/views/unauth.jsp").forward(request, response);
					}
				}
			});
			
			
			//cookie实现记住我   在其有效时间内免登陆功能     注意前端页面checkbox 的 name属性改为remember-me 框架能识别的参名
			http.rememberMe();
			
		}
	
	
	
}
