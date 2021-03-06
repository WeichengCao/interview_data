<center>C/C++</center>

## 内存对齐

为什么要进行内存对齐

1.平台原因（移植）：不是所有的硬件平台都能访问任意地址上的任意数据；某些硬件平台只能在某些地址处取特定类型的数据，否则抛出异常

2.性能原因：数据结构（尤其是栈）应该尽可能的在自然界边界上对齐，原因在于，为了访问未对齐的内存，处理器需要做两次内存访问；而对齐的内存访问仅需要一次访问

对齐规则

1.如果设置了内存对齐为 i 字节，类中最大成员对齐字节数为j，那么整体对齐字节n = min(i, j)  （某个成员的对齐字节数定义：如果该成员是c++自带类型如int、char、double等，那么其对齐字节数=该类型在内存中所占的字节数；如果该成员是自定义类型如某个class或者struct，那个它的对齐字节数 = 该类型内最大的成员对齐字节数《详见实例4》）

2.每个成员对齐规则：类中第一个数据成员放在offset为0的位置；对于其他的数据成员（假设该数据成员对齐字节数为k），他们放置的起始位置offset应该是 min(k, n) 的整数倍

3.整体对齐规则：最后整个类的大小应该是n的整数倍

4.当设置的对齐字节数大于类中最大成员对齐字节数时，这个设置实际上不产生任何效果（实例2）；当设置对齐字节数为1时，类的大小就是简单的把所有成员大小相加

[内存对齐地址](http://www.cnblogs.com/TenosDoIt/p/3590491.html)

[new和malloc的区别](http://www.cnblogs.com/QG-whz/p/5140930.html)