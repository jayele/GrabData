#!/bin/bash
#获取指定从多少页下载到多少页上的所有链接

read -p '下载从第几页开始?' FROM
read -p '下载到第几页结束?' END

touch page.link
link_save_path=`pwd`/page.link

for (( i = FROM; i <=END; i++ )); do
	url='http://xianyang.liebiao.com/jiajiao/index'$i'.html'
	echo $url
	lynx -dump -listonly $url | egrep '[0-9]{9}' | head -20 | awk -F '. ' '{print $3}' >> $link_save_path

done


