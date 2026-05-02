-- 在加载标签页前，先创建一个table来存储内容引用
local contentFrames = {}

-- 加载标签页时存储引用
local fContent = Instance.new("Frame")  -- 先创建容器...

-- 加载部分改为：
tabs.functions.createContentFrame(ContentArea)
tabs.fflag.createContentFrame(ContentArea)
tabs.sensitivity.createContentFrame(ContentArea)
tabs.accessories.createContentFrame(ContentArea)
tabs.settings.createContentFrame(ContentArea)

tabs.functions.populate()
tabs.fflag.populate()
tabs.sensitivity.populate()
tabs.accessories.populate()
tabs.settings.populate()

-- 初始隐藏所有内容（除了第一个）
-- 通过遍历ContentArea的子对象来隐藏非活动标签