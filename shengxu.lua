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

function fetchChapterList()

    local dt_list = List.new()
    local error_return = {}
    error_return.size = -1;

    local JsoupClass = luajava.bindClass("com.reader.app.module.jsoup.JsoupHelper")
    local document = JsoupClass:connect("http://www.booktxt.net/2_2219/")
    if (document == nil) then
        return error_return
    end
    local Elements_elements = document:select("#wrapper .box_con dl")
    local Elements_Iterator = Elements_elements:iterator()
    while (Elements_Iterator:hasNext()) do
        local item = Elements_Iterator:next()
        local dt_elements = item:children();
        local dt_element_iterator = dt_elements:iterator();
        while (dt_element_iterator:hasNext()) do
            local dt_item = dt_element_iterator:next()
            if (dt_item:tagName() == "dt") then
                List.pushBack(dt_list, List.new())
            else
                if (List.size(dt_list) > 0) then
                    --print(dt_item:outerHtml())
                    local dd_list = List.get(dt_list, List.size(dt_list)-1)
                    local info = {}
                    local dd_item = dt_item:child(0)
                    info.href = dd_item:attr("href")
                    info.text = dd_item:text()
                    List.pushBack(dd_list, info)
                    --print(dd_item:outerHtml())
                    --print(dd_item:attr("href"))
                    --print(info.text)
                end
            end


        end

        local testList = List.get(dt_list, 1)
        for i=0,List.size(testList) do
            local s = List.get(testList, i)
            if (s == nil) then
                print("testlist is nil\n")
            else
                --print("testlist not nil\n")
                --print(s.href)
            end
            --print()

            --print(s["href"])
            --print("连接后的字符串 "..table.concat(s,", "))
        end
        testList.size = List.size(testList)
        print(string.format("zzzxxx:%s", List.get(testList, 1).href))
        return testList
    end

end

function fetchChapterContent(url)
    local fullUrl = "http://www.booktxt.net/"..url;
    local jsoupClass = luajava.bindClass("org.jsoup.Jsoup")
    local content = ""
    local document = jsoupClass:connect(fullUrl):userAgent("Mozilla"):post()
    local elements_title = document:select("div[class=\"content_read\"] .bookname h1")
    local title_iterator = elements_title:iterator()
    while(title_iterator:hasNext()) do
        local title_item = title_iterator:next()
        content = content..title_item:text().."\r\n"
    end

    content = content.."\r\n"
    local elements_content = document:select("div[class=\"content_read\"] #content")
    local content_iterator = elements_content:iterator()

    while(content_iterator:hasNext()) do
        local content_item = content_iterator:next()
        local line_text = content_item:outerHtml()--content_item:text()
        --print("line_text:"..line_text)
        line_text = string.gsub(line_text, '<div id="content">',"")
        line_text = string.gsub(line_text, "<br>%s+","")
        line_text = string.gsub(line_text, "&nbsp;"," ")
        line_text = string.gsub(line_text, "     ","    ")
        line_text = string.gsub(line_text, ";%s+&lt;.*&gt;","")
        line_text = string.gsub(line_text, "</div>","")
        content = content..line_text.."\r\n"
    end
    content = string.gsub(content, "^%s*(.-)%s*$", "%1")

    return content
end


