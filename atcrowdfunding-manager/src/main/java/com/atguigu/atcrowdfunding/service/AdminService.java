package com.atguigu.atcrowdfunding.service;

import java.util.List;

import com.atguigu.atcrowdfunding.bean.TAdmin;

public interface AdminService {
	public TAdmin getAdminLogin(String loginacct,String userpswd);

	public List<TAdmin> listAdminPage(String keyWord);
	
	public void saveAdmin(TAdmin admin);

	public TAdmin getAdminById(Integer id);

	public void updateAdminById(TAdmin admin);

	public void deleteAdminById(Integer id);

	public void deleteBatch(List<Integer> idsList);
	
}
