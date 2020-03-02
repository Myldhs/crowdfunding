package com.atguigu.atcrowdfunding.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.bean.TRoleExample.Criteria;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.StringUtil;

@Service
public class RoleServiceImpl implements RoleService {

	@Autowired
	private TRoleMapper roleMapper;
	
	/**
	 * 执行按条件查询分页
	 */
	@Override
	public List<TRole> listRolePage(String keyWord) {
		
		//创建条件查询的条件对象
		TRoleExample example = new TRoleExample();
		
		if(StringUtil.isNotEmpty(keyWord)) {
			
			//条件不为空进行模糊查询,TRole表只有一个字段，所以查询条件只会有一种
			Criteria createCriteria = example.createCriteria();
			createCriteria.andNameLike("%"+keyWord+"%");//where name like %?%
			
		}
		List<TRole> roleList = roleMapper.selectByExample(example);
		
		return roleList;
	}
	/**
	 * 执行添加角色
	 */
	@Override
	public Integer saveRole(TRole role) {
		
		Integer row = roleMapper.insertSelective(role);
		
		return row;
	}
	/**
	 * 执行修改角色
	 */
	@Override
	public Integer updateRole(TRole role) {
		
		//按id进行修改
		Integer row = roleMapper.updateByPrimaryKeySelective(role);
		
		return row;
	}
	
	/**
	 * 单行删除角色
	 */
	@Override
	public Integer deleteRole(Integer id) {
		
		Integer row = roleMapper.deleteByPrimaryKey(id);
		return row;
	}
	
	//执行批量删除角色的方法
	@Override
	public Integer deleteBatch(List<Integer> idsList) {
		Integer row = roleMapper.deleteBatch(idsList);
		return row;
	}

}
