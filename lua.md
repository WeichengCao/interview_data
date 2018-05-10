<center>Lua</center>

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