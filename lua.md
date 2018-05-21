<center>Lua</center>

##  Lua介绍

lua是一门动态语言，所有的值都是第一类型。在lua中我们有巴中基本值类型：nil,boolean, number, string, table, function, userdata, thread; 在lua中，所有的值都用同一种结构来表示，即lua_TValue结构体；如下
	typedef struct lua_TValue {
		Value value_;			//值结构
		int tt;					//表示值类型
	} TValues;

	typedef union Value {
		GCObject *gc;			//可回收的对象
		void *p;				//light userdata
		int b;					//booleans
		lua_CFunction f;		//light c functions
		lua_Integer i;			//integer numbers
		lua_Number n;			//float numbers
	}

	typedef GCObject {			//CommonHeader
		GCObject *next;
		lua_tyte tt;
		lua_byte marked;
	}

	typedef struct TString {
		CommonHeader;
		//...
	} TString

	typedef struct Table {
		CommonHeader;
		lu_byte flag;
		lu_byte lsizenode;
		unsigned int sizearray;
		TValue *array;
		Node *node;
		Node *lastfree;
		struct Table *metatable;
		GCObject *gclist;
	}

	union GCUnion {
		GCObject gc;
		struct TString ts;
		struct Udata u;
		union Closure cl;
		struct Table h;
		struct Proto p;
		struct lua_State th;
	}

在lua中， 所有的值都是归属于lua_TValue这一个在结构体， 所有值都用Value结构来表示，但是这些值中还有gc对象和非gc对象的划分，这里gc对象的意思是需要lua gc进行内存回收的对象，如字符串，table等。 而bool， int 类型则不需要。Table，TString等gc对象包含有相同的CommonHeader，通过union GCUnion进行和tt（类型值）进行转换。

lua的字符串：

Lua 为每个字符串只保留一份拷贝，而且字符串是不变的：一旦内部化，字符串将不可更改。字符串的散列值由一个结合了位运算和数学运算的简单表达式计算出来，计算过程中会对所有数据位进行随机洗牌。当字符串内部化时，散列值被保存起来，以便后面的字符串比较和表索引操作能快速进行。如果字符串太长，那么散列函数就不再逐个考察每个字节，因而能快速计算长字符串的散列值。避免长字符串处理时的性能损失是非常重要的，因为在 Lua 中 ，计算长字符串的散列值是很普遍的。例如，在 Lua 中经常将整个文件读入一个长字符串中进行处理。

lua的table：
lua的table是唯一的表示数据结构的工具。Lua 中的表是关联数组，即可以通过任何值（除了 nil）来索引表项，表项可以存储任何类型的值。此外，表是动态的，当有数据加入其中（对不存在的表项赋值），或从中移除数据（将 nil 赋给表项）时，它们可以自动伸缩。Lua 中没有内置对数组类型的支持。Lua 不需要两套截然不同的指令来处理表和数组。 Table结构中，*array和sizearray用于表示数据部分，node则用于表示哈希表部分。当表需要增长时，Lua 重新计算散列表部分和数组部分的大小。最初表的两个部分有可能都是空的。新的数组部分的大小是满足以下条件的最大的 n 值：1到 n 之间至少一半的空间会被利用（避免像稀疏数组一样浪费空间）；并且 n/2+1到 n 之间的空间至少有一个空间被利用（避免 n/2 个空间就能容纳所有数据时申请 n 个空间而造成浪费）。当新的大小计算出来后，Lua 为数组部分重新申请空间，并将原来的数据存入新的空间。

这种混合型结构有两个优点。第一，存取整数键的值很快，因为无需计算散列值。第二，也是更重要的，相比于将其数据存入散列表部分，数组部分大概只占用一半的空间，因为在数组部分，键是隐含的，而在散列表部分则不是。

lua的函数和闭包


##	Lua在线更新实现

项目中在线更新实现查看代码：lualib/base/reload.lua

基本原理是：保持住引用关系， 在引用关系内部做新旧替换

附上代码：

    function loadfile_ex(file_name, mode, env)                                                 
        mode = mode or "rb"
        local fp = io.open(file_name, mode)
        local data = fp:read("a")
        fp:close()
        local f, s = load(data, file_name, "bt", env)
        assert(f, s)
        return f
	end

    local module = {}                                                                            
    
    function import(dotfile)
       if module[dotfile] then
            return module[dotfile]
        end 
    
        local file_name = string.gsub(dotfile, "%.", "/") .. ".lua"
        local m = setmetatable({}, {__index = _G})
        local f = loadfile_ex(file_name, "rb", m)
        f() 
        module[dotfile] = m 
        return m
    end
    
    function reload(dotfile)
        if not module[dotfile] then
            return
        end 
    
        local new_m = module[dotfile]
        local bak_m = table_copy(new_m)
        local file_name = string.gsub(dotfile, "%.", "/") .. ".lua"
        local f = loadfile_ex(file_name, "rb", new_m)
        if not f then return end 
        f() 
    
        local visited, recu = {}, nil 
        recu = function(old, new)
            for k, v in pairs(new) do
                if not visited[k] then
                    visited[k] = true
                    if type(old[k]) == "table" and type(new[k]) == "table" then
                        recu(old[k], new[k])
                    else
                        old[k] = v
                    end
                end
            end
            for k, v in pairs(old) do
                if not visited[k] and not rawget(new, k) then
                    visited[k] = true
                    old[k] = nil
                end
            end
        end
    
        local ret, msg = pcall(function()
            for k, v in pairs(new_m) do
                if type(v) == "table" and type(bak_m[k]) == "table" then
                    recu(bak_m[k], v)
                    new_m[k] = bak_m[k]
                end
            end
        end)
    
        if not ret then
            print("reload fail:",  msg)
        else
            print("reload success:", file_name)
        end
    end
       
    

使用方式：

    local module = import(file_path)
	module.func()

从上面的代码中我们可以看到， 我们在全局中保存了一个module的table，以文件名为key值，保持住了对文件对象的引用。对模块进行在线更新的时候则是先copy一份模块对象，作为原模块，然后将原来的module对象作为load的env重新进行一次加载。这样我们得到了一份旧对象bak_m 和一份新对象 new_m; 然后对新对象进行递归遍历，对相同key的值，用new_m的值替换old中的值，最终得到一份替换完全的新表。在这种实现方式中我们没有支持更新upvalue， 因此在实现代码逻辑中需要注意一些编码方式。 我们不直接在闭包中实现函数内容，例如：
    
    function rpc_request(args, callback)
		callback(args)
	end
	
	rpc_request(args, function(args)
		dosomething1
		dosomething2
		dosomething3
	end)

	
而是

    rpc_request(args, function(args)
		rpc_callback(args)
	end)

	function rpc_callback(args)
		dosomething1
		dosomething2
		dosomething3
	end

在1的实现方式中，我们进行在线更新的话，原来的函数调用会有一个旧的函数对象，在线更新的时候会产生一个新对象，这时候同一个函数会出现两种不同的表现方式；而在2的实现方式中，我们将闭包函数中的实现提出来，即使闭包是旧的，但是闭包中函数也进行了更新，函数只会有一种表现方式。


[<h3>如何更新upvalue</h3>](https://blog.codingnow.com/2016/11/lua_update.html)