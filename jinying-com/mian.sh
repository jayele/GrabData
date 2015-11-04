#!/bin/bash
for page in *.html; do

cat $page | grep '电话' | awk -F '"_blank">' '{print $2}' > /tmp/$$.list

cat /tmp/$$.list | awk -F "<em>电话" '{print $1}' | awk -F '&' '{print $1}' >> info.txt
cat /tmp/$$.list | awk -F "<em>电话" '{print $2}' | awk -F "：" '{print $3}' | awk -F '<' '{print $1}' >> name.txt
cat /tmp/$$.list | awk -F "<em>电话" '{print $2}' | awk -F "：" '{print $2}' | awk -F '<' '{print $1}' >> tel.txt
done

cat <<EOF >jingying.html
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
      <th>电话</th>
      <th>学科</th>
 </tr>
EOF
for (( i = 1; i < 71; i++ )); do
	name=`cat name.txt | sed -n $i'p'`
	tel=`cat tel.txt | sed -n $i'p'`
	info=`cat info.txt | sed -n $i'p'`
	echo "<tr><td>$i</td><td>$name</td><td>$tel</td><td>$info</td></tr>" >> jingying.html
	echo $name,$tel,$info >> jingying.rsv
done

cat <<EOF >>jingying.html
</table>
</body>
</html>
EOF