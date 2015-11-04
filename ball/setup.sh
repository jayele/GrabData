#!/bin/bash
#############################
#抓取让分文件和比分文件
#生成RF.js BF.js
#
#vesion		v2
#autor		jayelee
#time		2015年07月01日13:20:55
##############################

cat<<EOF
			=============================================
					该版本暂时不支持跨月份抓取!!!!
			=============================================
EOF
read -p '从几月几号开始下载[输入样式:601,表示六月一号]?' FROM
read -p '下载到几月几号结束[输入样式:612,表示六月十二]?' END

BF=$PWD'/bf/'		# 下载比分文件保存路径
RF=$PWD'/rf/'		# 下载让分文件保存路径
WEB=$PWD'/web/'		# 保存RF.js,BF.js的保存路径
[ -d $BF ] && rm -f bf/* || mkdir -p $BF
[ -d $RF ] && rm -f rf/* || mkdir -p $RF
[ -d $WEB ] && rm -f web/RF.js web/BF.js web/ORD.js || mkdir -p $WEB

# 生成比分文件和让分文件链接地址
for (( i = FROM; i <=END; i++ )); do
	# 如果小于10月则在前面加个0  目前不能跨月下载
	# [ $FROM -lt 1000 ] && tmp='0'$i
	echo 'http://bdata.7m.cn/DataFile/20150'$i'/S2_fgb1.js?'$i >> /tmp/$$.bf
	echo 'http://bodds.7m.cn/bodds/hisdata/20150'$i'/curodds_4.js?'$i >> /tmp/$$.rf
done

cat<<EOF

					====================================================
					正在下载 比分文件.....
					====================================================

EOF
# 下载比分文件文件
wget -q -i /tmp/$$.bf -P $BF
[ $? -eq 0 ] && echo 'Successful ! 下载比分文件完成' || echo 'Fauire !! 下载比分文件失败'

cat<<EOF

					====================================================
					正在下载 让分文件.....
					====================================================

EOF
# 下载让分文件文件
wget -q -i /tmp/$$.rf -P $RF
[ $? -eq 0 ] && echo 'Successful ! 下载让分文件完成' || echo 'Fauire !! 下载让分文件失败'

#下载的总页面数
all=$(( END - FROM + 1))

# 统一比分文件 生成BF.js
cnt=0
for f in $BF/*;do
	sed "s/bDt/bDt$cnt/g" $f >> $WEB'BF.js'
	let cnt++
done

# 统一让分文件 生成RF.js
echo 'var bOdds = new Array();for(var i=0;i<'$all';i++){bOdds[i]=new Array;}' > $WEB'RF.js'
cnt=0
for f in rf/*;do
	sed "s/bOdds\[4\]/bOdds[$cnt]/g" $f >> $WEB'RF.js'
	let cnt++
done
cat<<EOF

					====================================================
						运行完成!!!
						右键打开下面链接查看结果
						http://localhost/ball/web/tongji.html
					====================================================

EOF
