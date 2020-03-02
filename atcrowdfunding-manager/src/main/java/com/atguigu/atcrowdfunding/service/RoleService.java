package com.atguigu.atcrowdfunding.service;

import java.util.List;

import com.atguigu.atcrowdfunding.bean.TRole;

public interface RoleService {

	List<TRole> listRolePage(String keyWord);

	Integer saveRole(TRole role);

	Integer updateRole(TRole role);

	Integer deleteRole(Integer id);

	Integer deleteBatch(List<Integer> idsList);

	
	
}
