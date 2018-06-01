-----------------快排---------------
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
