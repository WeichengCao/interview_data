# interview_data

## 1.简历重写

## 2.Lua源码相关
[a.Lua-Table底层实现</br>](lua.md#lua-table)
[b.Lua垃圾回收，标记清除法（四色），同时研究清楚collectgarbage接口的使用方式</br>](#Lua-Garbage)
	  【在以上讲清楚的基础上可以提及极限压测遇到的问题；以及lua 5.4版本的提升】</br>
[c.Lua在线更新的实现，闭包（upvalue）怎么更新？</br>](lua.md#lua-update)
[d.Lua协程实现，以及协程管理相关</br>]()
[e.Lua闭包实现，和函数有什么区别？</br>]()
[f.Lua大表该怎么使用？ 或者规避？</br>]()

## 3.Python相关
[a.Python的垃圾回收</br>]()
[b.Python的GIL锁</br>]()
[c.Python的list 和 map 的实现原理</br>]()
	
## 4.数据库相关
[a.MySQL引擎相关， MyIsam 和 InnoDB的区别</br>](sql.md)
[b.mongodb 和 mysql的区别</br>](sql.md)
[c.mongodb引擎，内存方面需要注意的点</br>](sql.md)
[d.数据库的索引怎么建立， B+树</br>](sql.md)
[e.内联和外联的查询；怎么优化数据库查询语句</br>](sql.md)

## 5.网络编程
[a.三次握手，四次挥手</br>](TCP.md)
[b.tcp 为什么是可靠的</br>](TCP.md)
[d.epoll: 水平触发和边际触发（边缘触发）</br>](epoll.md)
[e.select和epoll的区别</br>](epoll.md)
[f.简述protobuf，数据格式，优缺点</br>](protobuf.md)
[g.通讯协议如何定制（lualib/base/net.lua)</br>]()

## 6.操作系统
[a.简述linux系统信号机制</br>]()
[b.查看linux服务器内存和cpu占用，top指令各个字段的含义</br>]()
[c.iptables 防火墙</br>]()
[d.查找文件的几种方式以及优缺点</br>]()
[e.查找端口占用指令</br>]()
[f.linux上的通信模型（消息队列，信号量，锁，管道）</br>]()

## 7.C/C++
[a.内存对齐（struct字节数计算）</br>](c.md)
[b.C++虚函数（多态）</br>](c.md)
[c.jemalloc</br>](c.md)
[d.new和malloc的区别</br>](c.md)
	
## 8.skynet
[a.actor模型</br>](actor.md)
[b.skynet整体架构概述</br>](skynet.md)
[c.skynet协程管理</br>](skynet.md)
[d.skynet优缺点</br>](skynet.md)
[e.skynet如何进行通讯，调度（写并发）</br>](skynet.md)
[f.skynet.call是一个rpc模型</br>](skynet.md)

## 9.项目相关
[a.游戏服务器结构，代码结构</br>](game_dev.md)
[b.游戏战斗逻辑</br>]()
[c.游戏登陆流程，二维码登陆流程</br>](game.md)
[d.游戏服务器压测</br>]()
[e.robot的实现</br>]()
[f.游戏服务器的优化措施（网络，cpu性能，内存相关）</br>]()
[g.游戏合服逻辑</br>]()
[h.场景AOI算法</br>]()

## 10.海量数据处理
[a.海量数据处理题库</br>]()

## 11.算法与数据结构
[a.排序算法</br>]()
[b.链表，栈，队列，树，堆，哈希表基本操作及其应用场景</br>]()
[c.排行榜实现（可以试着用红黑树）</br>]()
