package com.atguigu.atcrowdfunding.service.impl;

import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;

@Service
public class MyUserDetailsService implements UserDetailsService {
	
	@Autowired
	private TAdminMapper adminMapper;
	
	@Autowired
	private TMenuMapper menuMapper;
	
	@Autowired
	private TPermissionMapper permissionMapper;
	
	
	/**
	 * 登录
	 */
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// 参数username是登录的用户名   loginacct 查询指定用户的信息
		TAdminExample example = new TAdminExample();
		example.createCriteria().andLoginacctEqualTo(username);
		List<TAdmin> listAdmin = adminMapper.selectByExample(example);
		//由前端传进来的用户名信息在数据库中查到的用户对象
		TAdmin tAdmin = listAdmin.get(0);
		
		//用户权限=【角色+权限】  用户权限集合 里面要保存用户拥有的角色和权限
		HashSet<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
		
		//去数据库中查询用户的角色信息
		List<TMenu> listRole = menuMapper.listRole(tAdmin.getId());
		
		//去数据库中查询用户的权限信息
		List<TPermission> listPermission = permissionMapper.listPermission(tAdmin.getId());
		
		//将用户的角色和权限信息封装为权限对象再放进用户权限集合中
		
		for (TMenu role : listRole) {
			String roleName = role.getName();
			authorities.add(new SimpleGrantedAuthority("ROLE_"+roleName));
		}
		
		for (TPermission permission : listPermission) {
			String permissionName = permission.getName();
			authorities.add(new SimpleGrantedAuthority(permissionName));
		}
		
		
		//  user是通过表单提交信息去数据库查找到的用户对象，封装进该的登录和权限信息用于后续与前台表单提交的信息进行身份验证与权限验证  验证通过后续就用这个user对象代表用户
		User user = new User(tAdmin.getLoginacct().toString(),tAdmin.getUserpswd().toString(),authorities);
		
		return user;
	}

}
