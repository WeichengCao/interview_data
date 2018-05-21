MyISAM与InnoDB的区别是什么？

1、 存储结构
MyISAM：每个MyISAM在磁盘上存储成三个文件。第一个文件的名字以表的名字开始，扩展名指出文件类型。.frm文件存储表定义。数据文件的扩展名为.MYD (MYData)。索引文件的扩展名是.MYI (MYIndex)。
InnoDB：所有的表都保存在同一个数据文件中（也可能是多个文件，或者是独立的表空间文件），InnoDB表的大小只受限于操作系统文件的大小，一般为2GB。

2、 存储空间
MyISAM：可被压缩，存储空间较小。支持三种不同的存储格式：静态表(默认，但是注意数据末尾不能有空格，会被去掉)、动态表、压缩表。
InnoDB：需要更多的内存和存储，它会在主内存中建立其专用的缓冲池用于高速缓冲数据和索引。

3、 可移植性、备份及恢复
MyISAM：数据是以文件的形式存储，所以在跨平台的数据转移中会很方便。在备份和恢复时可单独针对某个表进行操作。
InnoDB：免费的方案可以是拷贝数据文件、备份 binlog，或者用 mysqldump，在数据量达到几十G的时候就相对痛苦了。

4、 事务支持
MyISAM：强调的是性能，每次查询具有原子性,其执行数度比InnoDB类型更快，但是不提供事务支持。
InnoDB：提供事务支持事务，外部键等高级数据库功能。 具有事务(commit)、回滚(rollback)和崩溃修复能力(crash recovery capabilities)的事务安全(transaction-safe (ACID compliant))型表。

5、 AUTO_INCREMENT
MyISAM：可以和其他字段一起建立联合索引。引擎的自动增长列必须是索引，如果是组合索引，自动增长可以不是第一列，他可以根据前面几列进行排序后递增。
InnoDB：InnoDB中必须包含只有该字段的索引。引擎的自动增长列必须是索引，如果是组合索引也必须是组合索引的第一列。

6、 表锁差异
MyISAM：只支持表级锁，用户在操作myisam表时，select，update，delete，insert语句都会给表自动加锁，如果加锁以后的表满足insert并发的情况下，可以在表的尾部插入新的数据。
InnoDB：支持事务和行级锁，是innodb的最大特色。行锁大幅度提高了多用户并发操作的新能。但是InnoDB的行锁，只是在WHERE的主键是有效的，非主键的WHERE都会锁全表的。

7、 全文索引
MyISAM：支持 FULLTEXT类型的全文索引
InnoDB：不支持FULLTEXT类型的全文索引，但是innodb可以使用sphinx插件支持全文索引，并且效果更好。

8、 表主键
MyISAM：允许没有任何索引和主键的表存在，索引都是保存行的地址。
InnoDB：如果没有设定主键或者非空唯一索引，就会自动生成一个6字节的主键(用户不可见)，数据是主索引的一部分，附加索引保存的是主索引的值。

9、 表的具体行数
MyISAM：保存有表的总行数，如果select count() from table;会直接取出出该值。
InnoDB：没有保存表的总行数，如果使用select count() from table；就会遍历整个表，消耗相当大，但是在加了wehre条件后，myisam和innodb处理的方式都一样。

10、 CURD操作
MyISAM：如果执行大量的SELECT，MyISAM是更好的选择。
InnoDB：如果你的数据执行大量的INSERT或UPDATE，出于性能方面的考虑，应该使用InnoDB表。DELETE 从性能上InnoDB更优，但DELETE FROM table时，InnoDB不会重新建立表，而是一行一行的删除，在innodb上如果要清空保存有大量数据的表，最好使用truncate table这个命令。

11、 外键
MyISAM：不支持
InnoDB：支持
通过上述的分析，基本上可以考虑使用InnoDB来替代MyISAM引擎了，原因是InnoDB自身很多良好的特点，比如事务支持、存储 过程、视图、行级锁定等等，在并发很多的情况下，相信InnoDB的表现肯定要比MyISAM强很多。另外，任何一种表都不是万能的，只用恰当的针对业务类型来选择合适的表类型，才能最大的发挥MySQL的性能优势。如果不是很复杂的Web应用，非关键应用，还是可以继续考虑MyISAM的，这个具体情况可以自己斟酌。

存储引擎选择的基本原则

采用MyISAM引擎

R/W > 100:1 且update相对较少
并发不高
表数据量小
硬件资源有限
采用InnoDB引擎

R/W比较小，频繁更新大字段
表数据量超过1000万，并发高
安全性和可用性要求高
采用Memory引擎

有足够的内存
对数据一致性要求不高，如在线人数和session等应用
需要定期归档数据


<center>mongodb 和 mysql的区别 </center>
mysql是一种关系型数据库，它将数据存储在表中，并使用结构化的查询语句进行数据库访问（SQL）；在mysql中，我们根据预先定义的数据模式，并设置规则来管理表中字段之间的关系，相关信息可能存储在单独的表中，但通过使用关联查询来关联，通过这种方式，使得数据重复量被最小化。

mongodb则是将数据以bson的形式（二进制json）存储在文档中，并且每个文档中的bson串结构可能有所不同。mongodb使用动态模式，这以为这你可以在不首先定义结构的情况下创建记录，还可以通过创建新字段或删除现有的记录来更改结构。集合中的文档不需要具有相同的一组字段，数据是非规范化的。

mysql和mongo中术语上的区别
表		集合
行		文档
列		字段
joins	嵌入文档或者链接

<center>mongodb 存储引擎 </center>

inMemory - 将数据存储在内存中，停机后数据消失
WiredTiger - 将数据持久化存储在Disk Files中

WiredTiger 提供文档级别的并发控制，意味着，在同一时间内多个写操作能够修改同一个集合中的不同文档；当多个写操作修改同一个文档时候，必须以序列化方式执行，按顺序执行

[详情](https://www.cnblogs.com/ljhdo/p/4947357.html)

<center>数据库索引</center>

>第一，通过创建唯一性索引，可以保证数据库表中每一行数据的唯一性。
>
>第二，可以大大加快数据的检索速度，这也是创建索引的最主要的原因。
>
>第三，可以加速表和表之间的连接，特别是在实现数据的参考完整性方面特别有意义。
>
>第四，在使用分组和排序子句进行数据检索时，同样可以显著减少查询中分组和排序的时间。
>
>第五，通过使用索引，可以在查询的过程中，使用优化隐藏器，提高系统的性能。