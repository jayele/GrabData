#!/bin/bash

read -p '下载从第几页开始?' FROM
read -p '下载到第几页结束?' END

for (( i = FROM; i <=END; i++ )); do
	url='http://xa.58.com/jiajiao/pn'$i
	echo $url
	lynx -dump -listonly $url | egrep '[0-9]{14}x.shtml$' | awk -F ':' '{print "http:"$2}' | uniq >> /tmp/$$.all_link
done
cat <<EOF
		============================================
				网页中所有链接采集完毕
				是否开始开始下载所有链接问价?
				输入0:表示先不下载
				输入1:表示立刻下载
		=============================================
EOF

read -p '>>>>>>>>>>>在这里输入:' answer
while [[ $answer != 0  ]] && [[ $answer != 1 ]]; do
	read -p '>>>>>>>>>>清输入0(不下载)或1(立即下载):' answer
done
if [[ $answer -eq 0 ]]; then
	pagelink=page.link$RANDOM
	echo '++ 你输入了'$answer,"即将退出,所有链接将保存在当前文件夹下的[$pagelink]中."
	cat /tmp/$$.all_link > $pagelink
	exit -1
else
cat <<EOF
	+++++++++++++++++++++++++++++++++++++++++
					 +
	++ 即将开始下载 所有链接网页 .......
EOF
	read -p '++ 为了下载的文件将新建一个文件夹,你想命名为什么?或者直接回车默认名为data >>:' whichdir
	[ -z $whichdir ] && whichdir='data'
	mkdir $whichdir
	cd $whichdir
	wget -i /tmp/$$.all_link

	if [[ $? -eq 0 ]]; then
		#表示下载完成
		cat<<EOF
		===========================================
			==================================
			  ============================
				=======================
				 >>所有链接下载完成<<
			+
			+ 下一步你要做的工作是进入链接文件保存的目录	
			+ 进入链接文件所
			+ 执行这个命令==>bash ../getneed.sh
			+
EOF
	bash ../getneed.sh
	fi
fi


