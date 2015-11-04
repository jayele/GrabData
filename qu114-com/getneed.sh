#!/bin/awk

tmpfile='/home/jayelee/shell/jiajiaowang/tmpfile'

index=1
cate=''
for page in  *.html
do
#正则匹配<h1>标题中的内容
h1=`cat $page  | grep '<h1>'`
i=1
while [[ $i -lt 15 ]]; do
	case $i in
		1)
			cate=$(echo $h1 | grep -o '英语')
			;;
		2)
			cate=$(echo $h1 | grep -o '数学')
			;;
		3)
			cate=$(echo $h1 | grep -o '艺术')
			;;
		4)
			cate=$(echo $h1 | grep -o '历史')
			;;
		5)
			cate=$(echo $h1 | grep -o '语文')
			;;
		6)
			cate=$(echo $h1 | grep -o '辅导班')
			;;
		7)
			cate=$(echo $h1 | grep -o '生物')
			;;
		8)
			cate=$(echo $h1 | grep -o '地理')
			;;
		9)
			cate=$(echo $h1 | grep -o '政治')
			;;
		10)
			cate=$(echo $h1 | grep -o '奥数')
			;;
		11)
			cate=$(echo $h1 | grep -o '文综')
			;;
		12)
			cate=$(echo $h1 | grep -o '理综')
			;;
		13)
			cate=$(echo $h1 | grep -o '化学')
			;;
		*)
			echo '辅导班' > /tmp/xxx.cate
			break
			;;
	esac
	if [[ $? -eq 0 ]];then
		echo $cate > /tmp/xxx.cate
		break
	else
		let i++
		echo $cate > /tmp/xxx.cate
	fi
done
cate=`cat /tmp/xxx.cate`
echo $cate
#提取信息
cat $page | grep 'class="contactvalue"' | awk -F'[<>]' '{for(i=1;i<=NF;i++){if($i~/'$keyword'/){print $i}}}' | sed '/^$/d' > $tmpfile
#cat $tmpfile

name=`cat $tmpfile | sed -n '7p'`
info=`cat $tmpfile | sed -n '9p'`
tel=`cat $tmpfile | sed -n '20p'`

echo $name | grep 'target="_blank"' >> /dev/null
if [[ $? -eq 0 ]];then
	name=`cat $tmpfile | sed -n '8p'`
	tel=`cat $tmpfile | sed -n '17p'`
	info='(个人)'
fi

echo $tel | grep 'span title' >> /dev/null
if [[ $? -eq 0 ]];then
	tel=`cat $tmpfile | sed -n '29p'`
fi

echo $tel | grep '^400' >> /dev/null
if [[ $? -eq 0 ]];then
	continue
fi

echo $info | grep 'div' >> /dev/null
if [[ $? -eq 0 ]];then
	name=' '
	info="(机构)"
	tel=`cat $tmpfile | sed -n '7p'`
fi

# echo $name,'----',$info,'----',$tel
# echo $h1
echo "$tel*</td><td><strong>$name</strong></td><td>$info</td><td>$tel</td><td>$cate</td></tr>" >> /tmp/$$.table
echo $tel"*"$name,$info,$tel,$cate >> /tmp/$$.csv
let index++
done

cat <<EOF >index.html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
<style>
* {font-family: "Microsoft YaHei", Arial, sans-serif; }
body { background-color:#3c3c3c;}
h1, table { text-align: center; }
table {border-collapse: collapse;  width: 85%; margin: 0 auto;box-shadow: 1px 1px 15px #000}
th, td { padding: 1rem; font-size: 1rem; cursor: pointer;}
tr {background: hsl(50, 50%, 80%); }
tr, td { transition: .1s ease-in;-webkit-transition: .1s ease-in; } 
tr:first-child {background: hsla(12, 100%, 40%, 0.5); }
tr:nth-child(even) { background: hsla(50, 50%, 80%, 0.7); }
td:empty {background: hsla(50, 25%, 60%, 0.7); }
tr:hover:not(#firstrow) { font-size:4rem; background:purple;box-shadow: 0px 3px 7px rgba(0, 0, 0, 0.5);}
tr:hover:not(#firstrow) td { font-weight:400;color:#fff;}
.mask{color: transparent;text-shadow: 0 0 3px #000;}
</style>
<script>
window.onload=function() {var oTr = document.getElementsByTagName('tr');
	for (var i=1,len = oTr.length ; i < len; i++) {
		oTr[i].index = i;
		oTr[i].onclick=function() {
			if (oTr[this.index].className=='mask') {
				oTr[this.index].className = '';
			} else {
				oTr[this.index].className='mask';
			}
		}
	};
}
</script>
</head>
<body>
	<h1>家教-www.xa.qu114/jiajiao/</h1>

<table id="racetimes">
<tr id="firstrow">
      <th>ID</th>
      <th>联系人</th>
      <th>形式</th>
      <th>电话</th>
      <th>学科</th>
  </tr>
EOF
######这条命令太强大了,直接按照指定索引进行排序并去除重复行
#awk '!x[$0]++' filename
#下面这条也能去重复行
#sort -n /tmp/$$.table | uniq > tmp

#原始的进行排序去重的方法
#awk -F '*' '!x[$1]++' /tmp/$$.table  | awk 'BEGIN { FS="*";i=1 } { print "<tr><td>"i$2;i++ }' >> index.html
#awk 'BEGIN { FS="*";i=1;} { if(!x[$1]++) { print $1;i++ } }' /tmp/$$.table

awk 'BEGIN { FS="*";i=1;} { if(!x[$1]++) { print "<tr><td>"i$2;i++ }}' /tmp/$$.table >> index.html
awk 'BEGIN { FS="*" } { if(!x[$1]++) { print $2 }}' /tmp/$$.csv > result.csv
# 上面这条命令的解释:
# 
#
#
#


#sort -n /tmp/$$.csv | uniq | awk -F '*' '{print $2}' > result.csv
#sort -u /tmp/$$.table |  awk 'BEGIN { FS="*";i=1 } { print "<tr><td>"i$2;i++ }' >> index.html

cat <<EOF >>index.html
</table>
</body>
</html>
EOF
