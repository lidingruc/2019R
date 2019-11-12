# R2019

本课程旨在帮助零基础的本科生掌握统计学和数据科学的基础概念和方法，掌握R和Python的基础操作，避免初学中的常见陷进和困难，明了数据科学技能积累的自学路径；相关知识和技术入门难度不大，但如果想熟练掌握并能自如应用则需要自己高强度练习和使用，比较适合想集中精力在相关方面有所突破的学生而非想简单了解一下的学生。

平时成绩占70%，由7次左右作业决定；期末考试成绩占总成绩的30%，根据1.5小时的随堂开卷实战考试表现给定，以区分出学习投入且效果较好的优秀学生；本课程90+以上的优秀人数不超过30%。


李丁

liding@ruc.edu.cn

中国人民大学中国调查与数据中心

中国人民大学社会与人口学院


# 《数据科学与社会研究》课程安排如下

## 第1讲、起航：备战大数据时代

课程介绍：课时有限，这个学期鸡血不打了，直接进入准备阶段吧！

课程指引：请认真阅读

http://note.youdao.com/noteshare?id=351a5e712274bd552b70aeb557a9cae5

课后阅读：
了解两本主要的教材风格和结构：
http://moderndive.com/index.html
http://r4ds.had.co.nz/introduction.html


## 第2讲、登高：数据、信息、知识与理论

课前预习：找一本社会研究方法教材速读一遍或者看看邱泽奇老师的社会调查研究方法的在线课程，对社会研究有些概念。

课堂演示：社会研究方法体系串讲（PPT ）。

PPT文件：https://github.com/lidingruc/R2019/blob/master/%E7%AC%AC%E4%BA%8C%E8%AE%B2.pdf

提交作业1：将PPT中关于抽样、统计检验、机器学习的介绍回顾一遍，并将课后阅读链接中相关的代码誊写到R scripts中，并运行一遍，在确保没有错误能够完整运行外，给各段命令加上自己的评注，帮助理解相关命令。


## 第3讲、立靶：R数据汇总和可复制性研究

课前预习：重点阅读r4ds教材中数据可视化和数据分析流程部分

https://ismayc.github.io/rbasics-book/index.html
http://r4ds.had.co.nz/data-visualisation.html

课堂演示：R界面和操作的简单介绍，tidyverse数据分析过程展示，github的使用展示，时间允许详细展示data-visualisation并介绍作业的做法。

演示概要参考：

http://note.youdao.com/noteshare?id=94c815919f88613d071d2254934ca53e

提交作业2：认真阅读https://github.com/hadley/r4ds/blob/master/visualize.Rmd（其输出结果为：http://r4ds.had.co.nz/data-visualisation.html） 理解ggplot图形语法和Rmarkdown的原理，将visualize.Rmd中的有效命令誊录到R scripts中并运行，如果有错误找出并尝试解决，注意格式并加上自己的评注。

## 第4讲、夯基：R基础入门与数据处理

课前预习：肖凯90分钟（推荐,优酷搜索 R语言快速入门 SupStat 分5集 ）：http://v.youku.com/v_show/id_XNjYyNzczMTgw.html?spm=a2h0j.11185381.listitem_page1.5!5~A&f=23488136&from=y1.2-3.4.5

重点阅读
http://r4ds.had.co.nz/tibbles.html
http://r4ds.had.co.nz/data-import.html
http://r4ds.had.co.nz/wrangle-intro.html
http://r4ds.had.co.nz/transform.html

课堂演示：R基础入门：R中的对象、函数、控制语句与数据框操作

提交作业3：研究学习https://github.com/lidingruc/2019R/blob/master/l4Rbasic/Rbasic.R 完成其中的练习题。

## 第5讲、备砖：变量处理

课前预习：

https://moderndive.com/3-wrangling.html

http://r4ds.had.co.nz/factors.html

http://r4ds.had.co.nz/strings.html

http://r4ds.had.co.nz/dates-and-times.html


提交作业4：将 https://github.com/moderndive/ModernDive_book/blob/master/03-wrangling.Rmd 中的命令转移到R scripts文件中，并完成其中的练习题。


## 第6讲、备砖：数据管理

课前预习：

http://r4ds.had.co.nz/tidy-data.html

http://moderndive.com/4-tidy.html

http://r4ds.had.co.nz/relational-data.html


提交作业5：将 http://r4ds.had.co.nz/tidy-data.html 中的命令转移到R scripts文件中，并完成其中的练习题。
一道附加练习题，做出来了对期末考试和以后数据整理实战都有帮助：请根据发放给大家的cgss2013数据，汇总出受访家庭中包括受访者在内的全部家庭成员的年龄、性别、同吃同住、经济独立与否、已婚状况。CGSS访问的是18周岁以上人口，CGSS问卷回答者对CGSS受访户内同住成人的代表性如何，比如他们的平均年龄存在显著差异吗？



## 第7讲、探索：统计汇总与作图

课前预习：

http://moderndive.com/3-wrangling.html（分类汇总部分）

http://r4ds.had.co.nz/exploratory-data-analysis.html

http://moderndive.com/2-viz.html

http://r4ds.had.co.nz/data-visualisation.html

课堂演示：利用基础命令和ggplot作图
提交作业6：将 http://r4ds.had.co.nz/exploratory-data-analysis.html 中的命令转移到R scripts文件中，并完成其中的作业题。
附加练习题：


## 第8讲、推论：统计检验

课前预习:第二讲讲义中关于抽样和统计推论的部分

http://moderndive.com/7-sim.html

http://moderndive.com/B-appendixB.html

http://moderndive.com/8-sampling.html

http://moderndive.com/9-ci.html

http://moderndive.com/10-hypo.html

https://github.com/andrewpbray/infer


课堂演示:如何用R来进行卡方检验、T检验、方差检验，模拟抽样分布

提交作业7：运行 https://moderndive.com/9-hypothesis-testing.html 中的命令，并完成其中的learning check


## 第9讲、建模：线性回归、回归诊断与拓展

课前预习：回归模型相关的内容

http://r4ds.had.co.nz/model-basics.html

http://r4ds.had.co.nz/model-building.html

https://moderndive.com/5-regression.html

https://moderndive.com/6-multiple-regression.html

https://moderndive.com/10-inference-for-regression.html

交互效应：http://faculty.smu.edu/kyler/courses/7312/interact.pdf

回归诊断：https://socialsciences.mcmaster.ca/jfox/Courses/Brazil-2009/index.html

回归诊断：jfox随书材料 https://socialsciences.mcmaster.ca/jfox/Books/RegressionDiagnostics/index.html

GLM模型：https://socialsciences.mcmaster.ca/jfox/Courses/SPIDA/index.html

SEM模型：https://socialsciences.mcmaster.ca/jfox/Courses/R/IQSBarcelona/index.html

高级模型与编程： https://socialsciences.mcmaster.ca/jfox/

统计模型示例：https://stats.idre.ucla.edu/other/dae/

提交作业8：未定。


## 第10讲、连通：网络分析

课前预习：预习社会网络分析的基本概念和历史

陈华珊课件：http://www.istata.cn/wp-content/uploads/2013/11/huashan_sna_visualization_2017.

学习内容：斯坦福大学网络分析实操资料集http://sna.stanford.edu/rlabs.php 理论教材https://www.cs.cornell.edu/home/kleinber/networks-book/

扩展自学材料列表：http://note.youdao.com/share/?id=28c7b0a4e947ae29462fb424cf11dd21&type=note#/

课堂演示：网络数据的基本概念与描述

提交作业9：未定。


## 第11讲、邻里：空间分析

课前预习：空间分析的基本原理

入门教材：GIS与空间分析入门https://mgimond.github.io/Spatial/index.html 
朱可夫示例：http://www.people.fas.harvard.edu/~zhukov/spatial.html

孙秀林空间建模示例：http://note.youdao.com/noteshare?id=4f4180ea28db7fdd238b882b681c5cd2

扩展自学材料列表：http://note.youdao.com/noteshare?id=92cbe89d3e03cc530ac28c4a0eb6449e


课堂演示：空间数据的基本介绍与作图 

提交作业10：未定。


## 第12讲、语言：文本分析

课前预习：

教材Text Mining with R! 
http://tidytextmining.com/ sourcecode on GitHub（https://github.com/dgrtwo/tidy-text-mining）.

扩展自学材料列表：http://note.youdao.com/noteshare?id=f0d94703ba72b57c54ad9318bdf0f274

python安装说明：http://note.youdao.com/noteshare?id=8b5797ca96ee80737a6a9048c0423b6f

python入门：http://note.youdao.com/noteshare?id=ab8f1f4e84519a6eb3881c8d7ca37841

课堂演示：基于R和python的文本分词、词云、主题、情感分析

提交作业11：未定。

## 第13讲、采集：爬虫与数据获取

课前预习：网页原理http://note.youdao.com/noteshare?id=6d0aab0f55880292730ff9535488b356

课堂演示：用python爬取数据的原理与实战

自学资料：http://note.youdao.com/noteshare?id=57cc2a7d0f893b58d4fbb217f65f167d

python爬虫：http://note.youdao.com/noteshare?id=aa3b31703ff6468eb2c884494e11b939

python爬虫：http://note.youdao.com/noteshare?id=8d72a2741f381b292d40c7583047c891

提交作业12：尝试爬取北大未名BBS所有学生社团版面开版时间
https://bbs.pku.edu.cn/v2/board.php?bid=682
