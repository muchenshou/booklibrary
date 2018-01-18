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
--
require 'https://raw.githubusercontent.com/muchenshou/booklibrary/master/kankanba_base.lua'


function fetchChapterList()
    return KanKanBa.fetchChapterList("http://www.sbkk88.com/mingzhu/gudaicn/jigongquanchuan/")
end

function fetchChapterContent(url)
    return KanKanBa.fetchChapterContent(url)
end

