# -*- coding: utf-8 -*-
"""
crawler
"""


import requests #美味的汤~~来自《爱丽丝梦游仙境》同名诗歌。化平淡为神奇（通过定位HTML标签来组织复杂的网络信息）
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
import time

import random
# 小猪短租强化了反爬虫技术，有时候需要使用报头信息和cookie才能登陆，请更新下面的浏览器和cookie信息
# 下面加入了num_retries这个参数，经过测试网络正常一般最多retry一次就能获得结果

def getUrl(url,num_retries = 5):
    #ua = UserAgent()
    #headers = {'User-Agent':ua.random}
    user_agent ="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36"
    cookie="abtest_ABTest4SearchDate=b; Hm_lvt_92e8bc890f374994dd570aa15afc99e1=1576020024; gr_user_id=5e132793-9dc1-40d6-b68a-847c36532bf2; 59a81cc7d8c04307ba183d331c373ef6_gr_last_sent_cs1=N%2FA; _pykey_=ca034ee9-7b49-59d6-a7a3-0d102adbf69b; grwng_uid=41a4c50c-e582-4ee9-8c21-41800e1f0191; xz_guid_4se=26b41c29-8571-4a23-b9bf-c4c75e3d1b39; 59a81cc7d8c04307ba183d331c373ef6_gr_session_id=56fca658-a3c1-475e-9672-c8fe0b93e2d7; 59a81cc7d8c04307ba183d331c373ef6_gr_last_sent_sid_with_cs1=56fca658-a3c1-475e-9672-c8fe0b93e2d7; 59a81cc7d8c04307ba183d331c373ef6_gr_session_id_56fca658-a3c1-475e-9672-c8fe0b93e2d7=true; xzuuid=035821b3; rule_math=2jolrwftsg4; Hm_lpvt_92e8bc890f374994dd570aa15afc99e1=1576023179"
    headers={"User-Agent":user_agent,"Cookie":cookie}
    try:
        print(url)
        response = requests.get(url,headers = headers)
        response.encoding = response.apparent_encoding
        return response
    except Exception as e:
        if num_retries > 0:
            time.sleep(10)
            print(url)
            print("requests fail, retry!")
            return getUrl(url,num_retries-1) #递归调用
        else:
            print("retry fail!")
            print("error: %s" % e + " " + url)
            return #返回空值，程序运行报错
        
url = "http://bj.xiaozhu.com/fangzi/5098280314.html"
wb_data = getUrl(url)
soup = BeautifulSoup(wb_data.text,"lxml")
print(soup)



print(soup.h4)#定位标签,抽丝剥茧

print(soup.h4.em)
print(soup.h4.em.string,"\n")

print(soup.title)
print(soup.title.name)
print(soup.title.string,"\n")

print(soup.head,"\n")#如何快速找到心仪数据在网页中的位置呢？——chrome浏览器：检查工具是神器

infos = soup.find_all('h6')#类似于soup.tags模式
for info in infos:
    print(info.text)# .get_text():会把你正在处理的文档中所有的标签清除，返回一个只包含文字的字符串
print(len(infos),'\n')

infos = soup.find_all({'h4','h6'})#可以传入多个标签名称组成的列表，是或的关系。
for info in infos:
    print(info.get_text())
print(len(infos),'\n')

names = soup.find_all('a',{'class':'lorder_name'})#加入class变量，精准找数据
for name in names:
    print(name)

names = soup.find_all(class_='bg_box')#使用keyword技巧(PS:因为class是受保护的关键字，因此不能单独做参数名需要处理：class_)
#类比于:names=soup.find_all('','class':'lorder_name')
for name in names:
    print(name)

scorelist = soup.find_all(text='5分')#匹配字符段
print(len(scorelist))

#神器再现：使用chrome检查功能找到目标数据的位置，因为.select是一个全文搜索的方法，所以结果是列表！！
title = soup.select('div.con_l > div.pho_info > h4')[0].text
score = soup.select('li.top_bar_w2.border_right_none > em')[0].text
address = soup.select('div.pho_info > p > span')[0].text
print(address,title,score)

peitao = soup.select("div.info_r > div.intro_item_content > ul > li")
for item in peitao:
    if 's_ico_no' not in item.get('class')[0]:
        print(item.get_text())


#一个较完整的例子：：：
# 因为是单页面，使用 select 方法获得的元素又是一个列表，那么列表中的第一个元素且也是唯一一个元素即是我们要找的信息 用 “[0]” 索引将其取出
# 后在对其使用处理的方法，因为 beautifulsoup 的些筛选方法并不能针对列表类型的元素使用 ;)

title = soup.select(' div.con_l > div.pho_info > h4 > em')[0].text
address = soup.select(' div.pho_info > p > span')[0].text # 和 get('href') 同理，他们都是标签的一个属性而已，我们只需要的到这个属性的内容即可
price = soup.select('#pricePart > div.day_l > span')[0].text
pic = soup.select('#curBigImage')[0].get('src')   # “#” 代表 id 这个找元素其实就是找他在页面的唯一

host_name = soup.select('a.lorder_name')[0].text
host_gender = soup.select('div.member_pic > div')[0].get('class')[0]



# 请在此处打印并观察结果
print(title)
print(address)
print(price)
print(pic)

print(host_name)
print(host_gender)

# 根据结果观察不同性别会用不同的图标样式（class），设计一个函数进行转换
def print_gender(class_name):
    if class_name == 'member_ico1':
        return '女'
    if class_name == 'member_ico2':
        return '男'

print(print_gender(host_gender))

data = {
    'title':title,
    'address':address,
    'price':price,
    'pic':pic,
    'host_name':host_name,
    'host_gender':print_gender(host_gender)

}

print(data)


# -------------------补充------------------
# 如何批量获取链接
page_link = []  # <- 每个详情页的链接都存在这里，解析详情的时候就遍历这个列表然后访问就好啦~


def get_page_link(page_number):
    for each_number in range(1, page_number):  # 每页24个链接,这里输入的是页码。range用法，例如range(1,5) #代表从1到5(不包含5)[1, 2, 3, 4]
        full_url = 'http://bj.xiaozhu.com/search-duanzufang-p{}-0/'.format(each_number)
        wb_data = requests.get(full_url)
        soup = BeautifulSoup(wb_data.text, 'lxml')
        for link in soup.select('a.resule_img_a'):  # 找到这个 class 样为resule_img_a 的 a 标签即可
            page_link.append(link.get('href'))


# ---------------------
get_page_link(2)
print(len(page_link))

#如何批量获取数据  需要更新cookie，设定时间间隔
def get_data(page_link):
    for url in page_link:
        wb_data = getUrl(url) # 利用前面定义的函数
        soup = BeautifulSoup(wb_data.text, 'lxml')
        title = soup.select('div.con_l > div.pho_info > h4 ')[0].get_text()  #
        address = soup.select('div.pho_info > p')[0].get('title')  # 和 get('href') 同理，他们都是标签的一个属性而已，我们只需要的到这个属性的内容即可
        price = soup.select('div.day_l > span')[0].text  ##pricePart > div.day_l > span
        pic = soup.select('#curBigImage')[0].get('src')  # “#” 代表 id 这个找元素其实就是找他在页面的唯一
        host_name = soup.select('a.lorder_name')[0].text
        host_gender = soup.select('div.member_pic > div')[0].get('class')[0]
        data = {
            'title': title,
            'address': address,
            'price': price,
            'pic': pic,
            'host_name': host_name,
            'host_gender': print_gender(host_gender)

        }
        print(data)#在这里也可以将数据按照格式装进数据库了
        time.sleep(random.random()*3)

get_data(page_link)

