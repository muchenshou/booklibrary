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

KanKanBa = {}
KanKanBa.fetchChapterList = function(url)

    local error_return = {}
    error_return.size = -1;

    local JsoupClass = luajava.bindClass("com.reader.app.module.jsoup.JsoupHelper")
    local document = --JsoupClass:connect("http://www.sbkk88.com/mingzhu/laocanyouji/")
    JsoupClass:connect(url)
    if (document == nil) then
        return error_return
    end
    local Elements_elements = document:select(".leftList a")
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

KanKanBa.fetchChapterContent = function (url)
    local fullUrl = "http://www.sbkk88.com"..url;
    local jsoupClass = luajava.bindClass("com.reader.app.module.jsoup.JsoupHelper")
    local content = ""
    local document = jsoupClass:connect(fullUrl)
    if (document == nil) then return content end

    local elements_content = document:select("#f_title1 h1")
    if (elements_content ~= nil) then
        content = content..elements_content:text().."\n\n"
    end
    local elements_content = document:select("#f_content1 #f_article")
    local content_iterator = elements_content:iterator()
    while(content_iterator:hasNext()) do
        local item = content_iterator:next()
        local rawdata = item:html()

        rawdata = string.gsub(rawdata, "\n", "")
        rawdata = string.gsub(rawdata, "<div.+</div>", "")
        rawdata = string.gsub(rawdata, "<u>.-</u>%s?", "")
        rawdata = string.gsub(rawdata, "<br>", "br2nl")
        rawdata = string.gsub(rawdata, "</p>", "br2nl")
        rawdata = string.gsub(rawdata, "<.->", "")
        rawdata = string.gsub(rawdata, "br2nl%s*", "\n")
        rawdata = string.gsub(rawdata, "\n+", "\n")
        rawdata = string.gsub(rawdata, "\n%s+", "\n")
        rawdata = string.gsub(rawdata, "^%s*(.-)%s*$", "%1")
        rawdata = string.gsub(rawdata, "&.-;", "")
        content = content..rawdata
        print(content)

    end

    content = content.."\r\n"
    content = string.gsub(content, "^%s*(.-)%s*$", "%1")
    return content
end


