#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from pandas import DataFrame as df
import datetime

# 开始时间
sstart = starttime = datetime.datetime.now()
print starttime.strftime('%Y%m%d %H:%M:%S') + ' 开始。。。。。。'

################ 路径设置 ################
WORK_DIR = '/home/work/wangchao41/zdprice'
STATS_DIR = WORK_DIR + "/datas/"
NOW_ZD_PRICE = WORK_DIR + '/datas/now_zd_price.txt'
##########################################

# 当前线上价格
price_online = pd.read_csv(NOW_ZD_PRICE,sep='\t',dtype={'sloc1':int,'scate2':int,'price':float,'member_price':float})

# 流量初始数据
clks_path = STATS_DIR + 'clks.txt'
clk_count = pd.read_csv(clks_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'clks_one_day':int}).drop(['clks'],axis=1)
clk_count = clk_count.merge(price_online,how='inner')

# 有效点击率
valid_rate_path = STATS_DIR + 'valid_click_rate.txt'
valid_rate = pd.read_csv(valid_rate_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str})
## 对有效点击率进行调整 
### PC端增加10% M端增加20% APP端增加50%  最大达到100%
pc_adjust = 0.2;m_adjust = 0.2;app_adjust = 0.5
adjust_rate = pd.DataFrame({'platform':['pc','m','app'],'adjust_rate':[pc_adjust,m_adjust,app_adjust]})
valid_rate = valid_rate[['sloc1','scate2','platform','valid_rate']].merge(adjust_rate)
valid_rate['valid_rate_new'] = valid_rate['valid_rate'] + valid_rate['adjust_rate']
valid_rate.loc[lambda df: df.valid_rate_new>1.0, 'valid_rate_new'] = 1.0

# 有效流量
## 每个频道下精准广告每天可以得到多少点击
jz_valid_clks_path = STATS_DIR + 'jz_clks.txt'
jz_valid_clks = pd.read_csv(jz_valid_clks_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'clks_one_day':int}).rename(columns={'clks_one_day':'jz_clks_one_day'})

clk_count = clk_count.merge(valid_rate[['sloc1','scate2','platform','valid_rate_new']],how='left').fillna(1.0).merge(jz_valid_clks,how='left').fillna(0.0)
clk_count['predict_clks'] = clk_count['clks_one_day'] * clk_count['valid_rate_new']
clk_count.to_pickle(STATS_DIR + 'predict_clks.obj') # 序列化，便于多次使用

starttime = datetime.datetime.now()
print starttime.strftime('%Y%m%d %H:%M:%S') + ' 有效流量。。。。。。'


# 位置点击率
pos_ctr_path = STATS_DIR + 'pos_clks.txt'
pos_ctr = pd.read_csv(pos_ctr_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'pos':int,'clks':int})
all_clks = pos_ctr.groupby(['sloc1','scate2','platform'])['clks'].sum().reset_index().rename(columns={'clks':'all_clks'})
pos_ctr = pos_ctr.merge(all_clks,how='inner')
pos_ctr['pos_ctr'] = pos_ctr['clks']/pos_ctr['all_clks']
pos_ctr.sort_values(by=['sloc1','scate2','platform','pos'],inplace=True)
accumulate_pos_ctr = pos_ctr.groupby(['sloc1','scate2','platform'])['pos_ctr'].cumsum()
accumulate_pos_ctr.name = 'accumulate_pos_ctr'
pos_ctr = pd.concat([pos_ctr,accumulate_pos_ctr], axis=1)
pos_ctr = clk_count[['sloc1','scate2','platform']].merge(pos_ctr,how='left')[['sloc1','scate2','platform','pos','pos_ctr','accumulate_pos_ctr']]
pos_ctr.to_pickle(STATS_DIR + 'pos_ctr.obj') # 序列化


starttime = datetime.datetime.now()
print starttime.strftime('%Y%m%d %H:%M:%S') + ' 位置点击率。。。。。。'

"""
tmp = pos_ctr[['sloc1','scate2','platform','pos','accumulate_pos_ctr']]
# 某百分比流量对应的位置
clks_percent = 0.9
percent_pos = tmp[tmp['accumulate_pos_ctr']>=clks_percent].groupby(['sloc1','scate2','platform']).first().reset_index()
"""

# 精准-置顶位置
jz_pos_path = STATS_DIR + 'jz_pos.txt'
zd_pos_path = STATS_DIR + 'zd_stats.txt'
jz_pos = pd.read_csv(jz_pos_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'common_pos':int})
zd_pos = pd.read_csv(zd_pos_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'dispsub1':int})[['sloc1','scate2','clk01','cost1','cash1','dispsub1']]
zd_pos = zd_pos.merge(price_online[['sloc1','scate2']])

#jz_zd_pos = percent_pos.merge(jz_pos,how='left').merge(zd_pos,how='left').rename(columns={'common_pos':'common_pos_jz','dispsub1':'common_pos_zd'}).fillna(0)[['sloc1','scate2','platform','pos','common_pos_jz','common_pos_zd','accumulate_pos_ctr']]
#jz_zd_pos = clk_count.merge(jz_pos,how='left').merge(zd_pos,how='left').rename(columns={'common_pos':'common_pos_jz','dispuser1':'common_pos_zd'}).fillna(0)[['sloc1','scate2','platform','clks_one_day','valid_rate_new','jz_clks_one_day','predict_clks','common_pos_jz','common_pos_zd']]
jz_zd_pos = clk_count.merge(jz_pos,how='left').merge(zd_pos,how='left').rename(columns={'common_pos':'common_pos_jz','dispsub1':'common_pos_zd'}).fillna(0)
jz_zd_pos['start_pos'] = jz_zd_pos['common_pos_jz']+1
jz_zd_pos.loc[lambda df: df.common_pos_zd==0,'end_pos'] = jz_zd_pos['start_pos']+jz_zd_pos['common_pos_zd']
jz_zd_pos.loc[lambda df: df.common_pos_zd!=0,'end_pos'] = jz_zd_pos['start_pos']+jz_zd_pos['common_pos_zd']-1
jz_zd_pos.loc[lambda df: df.common_pos_zd<5,'end_pos'] = jz_zd_pos['end_pos']+5  # 增加置顶客户
jz_zd_pos.loc[lambda df: (df.common_pos_zd>=5) & (df.common_pos_zd<10),'end_pos'] = jz_zd_pos['end_pos']+10 # 增加置顶客户

# 在该精准-置顶位置下能获得多少点击
jz_pos_clk_tmp = jz_zd_pos.merge(pos_ctr,how='left',left_on=['sloc1','scate2','platform'],right_on=['sloc1','scate2','platform']).query('(pos>=start_pos) & (pos<=end_pos)')
jz_pos_clk_rate = jz_pos_clk_tmp.groupby(['sloc1','scate2','platform'])['pos_ctr'].sum().reset_index()
detail = clk_count.merge(jz_pos_clk_rate).merge(jz_zd_pos[['sloc1','scate2','platform','common_pos_jz','common_pos_zd','start_pos','end_pos']])
#detail = jz_zd_pos.merge(jz_pos_clk_rate,how='left').fillna(0.0)
detail['zd_get_clks'] = np.round(detail['predict_clks']*detail['pos_ctr'],0)
detail.loc[lambda df: (df.jz_clks_one_day!=0) & (df.zd_get_clks>df.jz_clks_one_day), 'zd_get_clks'] = detail['jz_clks_one_day']


starttime = datetime.datetime.now()
print starttime.strftime('%Y%m%d %H:%M:%S') + ' 精准-置顶位置。。。。。。'



# 精准ACP
jz_acp_path = STATS_DIR + 'jz_acp.txt'
jz_acp = pd.read_csv(jz_acp_path,sep='\t',dtype={'sloc1':int,'scate2':int,'platform':str,'position':int,'acp':float})
jz_acp = jz_acp.sort_values(['sloc1','scate2','platform','acp'])[['sloc1','scate2','platform','position','acp']]
jz_acp = jz_acp.join(jz_acp.groupby(['sloc1','scate2','platform'])['acp'].rank(),lsuffix='_jz',rsuffix='_rank')
jz_acp = jz_acp.merge(jz_acp.groupby(['sloc1','scate2','platform'])['acp_jz'].count().reset_index(),left_on=['sloc1','scate2','platform'],right_on=['sloc1','scate2','platform']).rename(columns={'acp_jz_x':'acp_jz','acp_jz_y':'acp_count'})
jz_acp.to_pickle(STATS_DIR + 'jz_acp.obj')

acp_percent = 0.3
jz_acp_result = jz_acp[(jz_acp['acp_rank'] <= acp_percent*jz_acp['acp_count']) | (jz_acp['acp_rank']<=1)].groupby(['sloc1','scate2','platform'])['acp_jz'].mean().reset_index()

starttime = datetime.datetime.now()
print starttime.strftime('%Y%m%d %H:%M:%S') + ' 精准ACP。。。。。。'

detail = detail.merge(jz_acp_result,how='left')
detail['zd_cnt'] = detail['end_pos'] - detail['start_pos']
#detail.loc[lambda df: df.common_pos_zd<10, 'zd_cnt'] = 10 # 置顶应该有的个数
detail['zdprice'] = np.round(detail['zd_get_clks']*detail['acp_jz']/detail['zd_cnt'],2)
detail.to_csv(STATS_DIR + 'result_detail.txt',sep='\t',index=False,encoding='utf-8')
summary = detail.groupby(['sloc1','scate2'])['zdprice'].sum().reset_index()
summary['sloc-scate'] = summary['sloc1'].astype(str)+ '-'+summary['scate2'].astype(str)


# 线上价格
summary = summary.merge(price_online,left_on=['sloc1','scate2'],right_on=['sloc1','scate2'])[['sloc1','scate2','zdprice','online_price','member_price']]

t = 0.8
summary['price'] = summary['zdprice'] + t*(summary['online_price'] - summary['zdprice'])
summary['diff'] = summary['price'] - summary['online_price']
summary['range'] = summary['diff']/summary['online_price']
summary.to_csv(STATS_DIR + 'result_summary.txt',sep='\t',index=False,encoding='utf-8')



endtime = datetime.datetime.now()


print '====== 耗时：' + str((endtime - sstart).seconds) + ' s '
