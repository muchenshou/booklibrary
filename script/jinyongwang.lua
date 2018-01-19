--
-- Created by IntelliJ IDEA.
-- User: songzhentao
-- Date: 2018/1/14
-- Time: 上午10:37
-- To change this template use File | Settings | File Templates.
--

require 'import'
import 'org.jsoup.nodes.Document'
import 'org.jsoup.nodes.Element'
import 'org.jsoup.select.Elements'


List={}

function List.new()
    return {first=0, last=-1}
end

function List.pushFront(list,value)
    list.first=list.first-1
    list[ list.first ]=value
end

function List.pushBack(list,value)
    list.last=list.last+1
    list[ list.last ]=value
end

function List.popFront(list)
    local first=list.first
    if first>list.last then error("List is empty!")
    end
    local value =list[first]
    list[first]=nil
    list.first=first+1
    return value
end

function List.popBack(list)
    local last=list.last
    if last<list.first then error("List is empty!")
    end
    local value =list[last]
    list[last]=nil
    list.last=last-1
    return value
end

function List.get(list, index)
    return list[index-list.first]
end

function List.size(list)
    return list.last - list.first + 1
end

function List.isEmpty(list)
    return list.last < list.first
end

Jinyongwang = {}

Jinyongwang.fetchChapterList = function (url)
    local error_return = {}
    error_return.size = -1;

    local JsoupClass = luajava.bindClass("com.reader.app.module.jsoup.JsoupHelper")
    local document = --JsoupClass:connect("http://www.sbkk88.com/mingzhu/laocanyouji/")
    JsoupClass:connect(url)
    if (document == nil) then
        return error_return
    end
    local Elements_elements = document:select(".main .mlist a")
    local Elements_Iterator = Elements_elements:iterator()
    local dd_list = List.new()
    while (Elements_Iterator:hasNext()) do
        local item = Elements_Iterator:next()
        local info = {}

        info.href = item:attr("href")
        info.text = item:text()
        List.pushBack(dd_list, info)


        print(info.href)

    end
    local testList = dd_list
    testList.size = List.size(testList)
    return testList
end

Jinyongwang.fetchChapterContent = function (url)
    local content = ""
    local fullUrl = "http://www.jinyongwang.com/yi/"..url;
    if string.gmatch(url, "^/") ~= nil then
        fullUrl = "http://www.jinyongwang.com"..url
    end
    local jsoupClass = luajava.bindClass("com.reader.app.module.jsoup.JsoupHelper")

    local document = jsoupClass:connect(fullUrl)
    if (document == nil) then return content end

    local elements_content = document:select("body .mbtitle")
    if (elements_content ~= nil) then
        content = content .. elements_content:text() .. "\n\n"
    end
    local elements_content = document:select("body .vertical .vcon p")
    local content_iterator = elements_content:iterator()
    while (content_iterator:hasNext()) do
        local item = content_iterator:next()
        local rawdata = item:text()
        content = content..rawdata .. "\n"
        print(rawdata)
    end

    content = content.."\r\n"
    content = string.gsub(content, "^%s*(.-)%s*$", "%1")
    return content
end


