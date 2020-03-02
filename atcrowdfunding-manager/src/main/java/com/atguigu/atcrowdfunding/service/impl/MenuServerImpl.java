package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;

@Service
public class MenuServerImpl implements MenuService {
	
	@Autowired
	private TMenuMapper menuMapper;
	
	@Override
	public List<TMenu> listAllMenu() {
		//查询所有菜单然后分成父节点集和子节点集
		//没有查询条件代表查询所有
		List<TMenu> listAllMenus = menuMapper.selectByExample(null);
		
		//保存父节点的集合
		List<TMenu> parentMenus = new ArrayList<TMenu>();
		
		//遍历找到所有的父节点
		for (TMenu tMenu : listAllMenus) {
			if(tMenu.getPid()==0) {
				parentMenus.add(tMenu);
			}
		}
		
		//为每个父节点找到他的子节点,将父节点和子节点进行关联
		for (TMenu tMenu : listAllMenus) {
			if(tMenu.getPid()!=0) {
				for (TMenu parent : parentMenus) {
					if(tMenu.getPid()==parent.getId()) {
						parent.getChildMenus().add(tMenu);
					}
				}
			}
		}
		//返回所有带着自己子节点的父节点集合
		System.out.println(parentMenus);
		return parentMenus;
	}

}






