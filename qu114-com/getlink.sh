#!/bin/bash
#将xa.qu114.com每页家教信息链接下载到/home/jayelee/all-jiajiao-Link.txt

read -p "从第几页开始? :" FROM
read -p "到第多少页? :" END

TMP_PATH='/home/jayelee/shell/qu114-com/link-jiajiao.tmp'

[ ! -F $SAVE_PATH ] && touch $SAVE_PATH
SAVE_PATH='/home/jayelee/shell/qu114-com/all-jiajiao-Link.txt'

#从官网多少页下载到多少页
for (( i = $FROM; i <= $END; i++ )); do
	#家教网每页的链接
	# 西安网址
	# url="http://m.qu114.com/xa-jiajiao/pn$i/"

	# 襄阳网址
	url="http://m.qu114.com/xa-jiajiao/pn$i/"
	lynx -dump  -listonly $url > $TMP_PATH
	tail -12 $TMP_PATH | awk -F '//m' '{print "http://xa"$2}' | awk -F 'xa-' '{print $1$2}' >> $SAVE_PATH
	sleep 1s
	echo '完成'$i'个:'$url
done
