package com.atguigu.atcrowdfunding.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TAdminExample.Criteria;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.atguigu.atcrowdfunding.util.StringUtil;

@Service
public class AdminServiceImpl implements AdminService{

	@Autowired
	//mapper接口的代理对象
	private TAdminMapper adminMapper;
	
	//登录的验证处理
	@Override
	public TAdmin getAdminLogin(String loginacct, String userpswd) {
		//用非id的查询条件需要用到条件对象
		TAdminExample example = new TAdminExample();
		
		//使用MD5对密码进行加密然后往数据库中保存加密后的密文 123=202cb962ac59075b964b07152d234b70
		String newPWD = MD5Util.digest(userpswd);
		
		//封装具体的查询条件(创建查询标准对象,里面封装了众多查询条件方法，调用那些方法就相当于为mapper映射文件中的sql语句后拼接对应的where查询条件)
		Criteria createCriteria = example.createCriteria();
		createCriteria.andLoginacctEqualTo(loginacct);//为sql语句拼接 where loginacct=?
		createCriteria.andUserpswdEqualTo(newPWD);//为sql语句拼接 where userpswd=?
		
		//然后根据查询条件查询
		List<TAdmin> adminlist = adminMapper.selectByExample(example);
		
		//对结果进行判断
		if(adminlist!=null&&adminlist.size()!=0) {
			//查询成功返回查询结果
			return adminlist.get(0);
		}else {
			//查询失败
			return null;
		}
	}

	//查询用户主页
	@Override
	public List<TAdmin> listAdminPage(String keyWord) {
		//查的还是用户表的内容
		TAdminExample example = new TAdminExample();
		
		//判断是否带条件查询
		if(StringUtil.isNotEmpty(keyWord)) {// select * from t_admin where loginacct like '%?%' or email like '%?%' or username like '%?%'
			//带条件查询  第一个条件模糊查询
			Criteria criteria1 = example.createCriteria();
			criteria1.andLoginacctLike("%"+keyWord+"%");
			
			//带条件查询  第二个条件模糊查询
			Criteria criteria2 = example.createCriteria();
			criteria2.andEmailLike("%"+keyWord+"%");
			
			//带条件查询  第三个条件模糊查询
			Criteria criteria3 = example.createCriteria();
			criteria3.andUsernameLike("%"+keyWord+"%");
			
			//条件之间用or连接做只要满足任意一个条件就查询
			example.or(criteria1);
			example.or(criteria2);
			example.or(criteria3);
			
		}
		//将处理后的条件对象传入
		List<TAdmin> adminList = adminMapper.selectByExample(example);
		
		return adminList;
	}

	//添加的方法
	@Override
	public void saveAdmin(TAdmin admin) {
		//前面页面上只有三个属性，TAdmin对象还差两个密码和创建时间,补全后才能添加到数据库中
		//修改一下  使用安全框架后 该用框架自带的加密器
		admin.setUserpswd(new BCryptPasswordEncoder().encode("123"));
		
		admin.setCreatetime(DateUtil.getFormatTime());
		
		//动态SQL执行有带非空验证等处理
		adminMapper.insertSelective(admin);
	}

	//获取修改的用户对象
	@Override
	public TAdmin getAdminById(Integer id) {
		TAdmin admin = adminMapper.selectByPrimaryKey(id);
		return admin;
	}

	//执行修改操作
	@Override
	public void updateAdminById(TAdmin admin) {
		
		adminMapper.updateByPrimaryKeySelective(admin);
		
	}

	//执行单行删除操作
	@Override
	public void deleteAdminById(Integer id) {
		
		adminMapper.deleteByPrimaryKey(id);
		
	}
	
	//执行批量删除方法
	@Override
	public void deleteBatch(List<Integer> idsList) {
		
		adminMapper.deleteBatch(idsList);
		
	}
	
	
	

}












