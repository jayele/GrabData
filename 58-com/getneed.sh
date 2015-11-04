#!/bin/bash
index=1
for page in *.shtml; do
	cat $page | grep '联系人\|phone tel\|<h1>' -A 2  > /tmp/$$.58tmp

	tel=`cat /tmp/$$.58tmp | sed -n '9p' | awk -F 'tel">' '{print $2}' | awk -F '<' '{print $1}'`
	echo $tel | grep '^400'	#400开头的电话过滤掉
	[ $? -eq 0 ] && continue
	[[ -z $tel ]] && continue >> /dev/null	#如果$tel为空也过滤掉,字符串比较最好使用[[  ]]

	h1=`cat /tmp/$$.58tmp | sed -n '1p' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}'`
	name=`cat /tmp/$$.58tmp | sed -n '7p' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}'`

	echo "$tel*</td><td><strong>$name</strong></td><td>$tel</td><td>$h1</td></tr>" >> /tmp/$$.table
	echo $tel"*"$name,$tel,$h1 >> /tmp/$$.csv
	let index++
	echo $index
done
#开始生成html文件
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
	<h1>家教-www.xa.58.com/jiajiao/</h1>

<table id="racetimes">
<tr id="firstrow">
      <th>ID</th>
      <th>联系人</th>
      <th>电话</th>
      <th>学科</th>
  </tr>
EOF

#按照电话号码来排序
awk 'BEGIN { FS="*";i=1;} { if(!x[$1]++) { print "<tr><td>"i$2;i++ }}' /tmp/$$.table >> index.html
awk 'BEGIN { FS="*" } { if(!x[$1]++) { print $2 }}' /tmp/$$.csv > result.csv

cat <<EOF >>index.html
</table>
</body>
</html>
EOF
