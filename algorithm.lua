-----------------排序---------------
-----------------快排---------------
--最坏O(n^2), 最好O(nlog(n)), 平均O(nlog(n)), 非稳定排序
function quicksort(l, s, e)
	if s < e then
		local p = partition(l, s, e)
		quicksort(l, s, p-1)
		quicksort(l, p+1, e)
	end
end

function partition(l, s, e)
	local pivot = l[e]
	local i = s - 1
	for j = s, e-1 do
		if l[j] >= pivot then
			i = i + 1
			swap(l, i, j)
		end
	end
	swap(l, i+1, e)
	return i + 1
end

function swap(l, i, j)
	local val = l[i]
	l[i] = l[j]
	l[j] = val
end

----------------堆排--------------------
--最坏O(nlog(n)), 最好O(nlog(n)), 平均O(nlog(n)), 非稳定排序
function heapify(l, i, e)
	local left = 2 * i
	local right = 2*i + 1
	local max = i
	if left <= e and l[left] > l[i] then
		max = left
	end
	if right <= e and l[right] > l[max] then
		max = right
	end
	if max ~= i then
		swap(l, i, max)
		heapify(l, max, e)
	end
end

function heapbuild(l, s, e)
	for i = math.floor((s+e)/2) + 1, 1, -1 do
		heapify(l, i, e)
	end
end

function heapsort(l, s, e)
	for i = 1, #l do
		heapbuild(l, 1, #l-i+1)
		swap(l, 1, #l-i+1)
	end
end

------------冒泡排序-------------
--最好O(n), 最坏O(n^2), 平均O(n^2); 是稳定排序
function bubblesort(l)
	for i = 1, #l do
		for j = i+1, #l do
			if l[i] > l[j] then
				swap(l, i, j)
			end
		end
	end
end


------------归并排序--------------
--最好O(nlog(n)), 最坏O(nlog(n)),平均O(nlog(n)), 是稳定排序
function mergesort(l, s, e)
	if s < e then
		local m = math.floor((s+e)/2)
		mergesort(l, s, m)
		mergesort(l, m+1, e)
		merge(l, s, m, e)
	end
end

function merge(l, s, m, e)
	local left, right = {}, {}
	for i = s, m do
		table.insert(left, l[i])
	end
	for j = m+1, e do
		table.insert(right, l[j])
	end

	local i, j = 1, 1
	for k = s, e do
		local flag = 0
		if left[i] and right[j] then
			if left[i] <= right[j] then
				l[k] = left[i]
				i = i + 1
			else
				l[k] = right[j]
				j = j + 1
			end
			flag = 1
		end
		if left[i] and flag == 0 then
			l[k] = left[i]
			i = i + 1
		end
		if right[j] and flag == 0 then
			l[k] = right[j]
			j = j + 1
		end
	end
end


-----------------查找---------------
-----------------顺序查找-----------
--最坏O(n) 最快O(1)
function normalsearch(l, key)
	for k, v in ipairs(l) do
		if v == key then
			return k
		end
	end
end

-----------------二分查找-----------
--前提是有序列表, 最坏O(log(n)), 最好O(1)
function binarysearch(l, key, s, e)
	while s <= e do
		local m = math.floor((s+e)/2)
		if l[m] == key then
			return m
		elseif l[m] > key then
			e = m - 1
		else
			s = s + 1
		end
	end
end

----------------哈希查找-----------------


-----------------二叉树------------------
----------------先序遍历-----------------
function preorder(t)
	if t then
		print(t.val)
		preorder(t.left)
		preorder(t.right)
	end
end


----------------中序遍历-----------------
function inorder(t)
	if t then
		inorder(t.left)
		print(t.val)
		inorder(t.right)
	end
end

----------------后序遍历-----------------
function tailorder(t)
	if t then
		tailorder(t.left)
		tailorder(t.right)
		print(t.val)
	end
end

----------------二叉查找树---------------
function treesearch(t, k)
	if t then
		if t.val == k then
			return t
		elseif t.val < k then
			return treesearch(t.right, k)
		else
			return treesearch(t.left, k)
		end
	end
end

function treesearch(t, k)
	local n = t
	while n do
		if n.val == k then
			return n
		elseif n.val < k then
			n = n.right
		else
			n = n.left
		end
	end
end

function minval(t)
	local n = t
	while n do
		if n.left then
			n = n.left
		else
			return n
		end
	end
end

function maxval(t)
	local n = t
	while n do
		if n.right then
			n = n.right
		else
			return n
		end
	end
end

--后继节点
function successor(t)
	if not t then return end
	if t.right then
		return minval(t.right)
	end
	local p = t.parent
	if p and p.left == t then
		return p
	end
	while p and p.right == t do
		t = p
		p = t.parent
	end
	return p
end

function predecessor(t)
	if not t then return end
	if t.left then
		return maxval(t.left)
	end
	local p = t.parent
	if p and p.right == t then
		return p
	end
	while p and p.left = t do
		t = p
		p = t.parent
	end
	return p
end

function newnode(v)
	return {val = v, left = nil, right = nil, parent = nil}
end

function insertnode(t, v)
	local n = newnode(v)
	if t == nil then
		t = n
		return t
	end
	local pre = nil
	while t do
		pre = t
		if t.val <= v then
			t = t.right
		else
			t = t.left
		end
	end
	if pre then
		if pre.val <= v then
			pre.right = n
		else
			pre.left = n
		end
		n.parent = pre
	end
end

function delnode(t, n)
	if not n.left and not n.right then
		local p = n.parent
		n.partent = nil
		if p.left == n then
			p.left = nil
		else
			p.right = nil
		end
	end
	if n.left and n.right then
		local k = successor(n)
		n.val = k.val
		delnode(t, k)
	else
		p = n.parent
		n.parnet = nil
		local k = n.left or n.right
		n.left = nil
		n.right = nil
		if p.left == n then
			p.left = k
		else
			p.right = k
		end
	end
end

----------------红黑树---------------
--跟节点一定为黑
--叶子节点一定为黑，为(nil)
--红节点的子女一定为黑
--任意节点到其子孙节点的所有路径上包含相同数目的黑节点(算法导论)
--Every path from a given node to any of its descendant NIL nodes contains the same number of black nodes.(维基百科)
--所以应该是任意节点到其叶子节点的所有路径上包含有相同数目的黑节点
--

--    y      x           
--  x  c   a   y         
--a  b        b  c       

function right_rotate(t, y)
	local x = y.left
	if not x then return end

	b = x.right
	x.parent = y.parent
	x.right = y
	y.left = b
	y.parent = x
	if b then
		b.parent = y
	end
	if x.parent == nil then
		t = x
	end
end

function left_rotate(t, x)
	local y = x.right
	if not y then return end
	
	b = y.left
	y.left = x
	y.parent = x.parent
	x.right = b
	x.parent = y
	if b then
		b.parent = x
	end
	if y.parent == nil then
		t = y
	end
end

function rb_newnode(v)
	return {val = v, left = nil, right = nil, parent = nil, color = "red"}
end

function rb_insert(t, v)
	local n = newnode(v)
	if t == nil then
		t = n
		n.color = "black"
		return t
	end
	local pre = nil
	while t do
		pre = t
		if t.val <= v then
			t = t.right
		else
			t = t.left
		end
	end
	if pre then
		if pre.val <= v then
			pre.right = n
		else
			pre.left = n
		end
		n.parent = pre
	end
	rb_insert_fixup(t, n)
end

function rb_insert_fixup(t, n)
	local p = rb_parent(n)
	if not p then
		rb_insert_fixup1(t, n)
	elseif p.color == "black" then
		rb_insert_fixup2(t, n)
	elseif rb_uncle(n) and rb_uncle(n).color == "red" then
		rb_insert_fixup3(t, n)
	else
		rb_insert_fixup4(t, n)
	end
end

function rb_insert_fixup1(t, n)
	if not rb_parent(n) then
		n.color = "black"
	end
end

function rb_insert_fixup2(t, n)
	return
end

function rb_insert_fixup3(t, n)
	local p = rb_parent(n)
	if p then
		p.color = "black"
		rb_uncle(n).color = "black"
		rb_grandparent(n).color = "red"
		rb_insert_fixup(t, rb_grandparent(n))
	end
end

function rb_insert_fixup4(t, n)
	--父亲是红，叔叔是黑，自己是红
	local p = rb_parent(n)
	local pp = rb_grandparent(n)
	if pp and pp.left.right == n then
		left_rotate(t, p)
		n = n.left
	elseif pp and pp.right.left == n then
		right_rotate(t, p)
		n = n.right
	end
	rb_insert_fixup4_2(t, n)
end

function rb_insert_fixup4_2(t, n)
	local p = rb_parent(n)
	local pp = rb_grandparent(n)
	if not p or not pp then
		return
	end
	if p = pp.left then
		right_rotate(pp)
	else
		left_roate(pp)
	end
	p.color = "black"
	pp.color = "red"
end

function rb_parent(n)
	return n.parent
end

function rb_grandparent(n)
	local p = rb_parent(n)
	if p then
		return rb_parent
	end
end

function rb_sibling(n)
	local p = rb_parent(n)
	if p then
		if p.left == n then
			return p.right
		else
			return p.left
		end
	end
end

function rb_uncle(n)
	local p = rb_parent(n)
	if p then
		return rb_sibling(p)
	end
end



--------------------数据结构的扩张--------------
--红黑树应用
--size[x] = size[left(x)] + size[right(x)] + 1

--选择第i小的元素
function size(n)
	return n and n.size or 0
end

function os_select(t, i)
	local compare = size(t.left) + 1
	if i == compare then
		return t
	elseif i > compare then
		os_select(right[t], i-compare)
	else
		os_select(left[t], i)
	end
end

function os_rank(t, x)
	local r = size(x.left) + 1
	y = x
	while y.parent do --//非根节点
		if y == y.parent.right then
			r = r + size(y.parent.left) + 1
			y = y.parent
		end
	end
	return r
end

function os_left_rotate(t, x)
	local y = x.right
	left_rotate(t, x)
	y.size = x.size
	x.size = size(x.left) + size(x.right) + 1
end

function os_right_rotate(t, y)
	local x = y.left
	right_rotate(t, y)
	x.size = y.size
	y.size = size(y.left) + size(y.right) + 1
end


function print_list(l)
	local ll = {}
	for _, val in ipairs(l) do
		table.insert(ll, tostring(val))
	end
	print("result:", table.concat(ll, ","))
end

local l = {7, 890, 12, 123, 00214, 2441, 3, 0, -18}
mergesort(l, 1, #l)
print_list(l)
