#!/bin/bash
# 从目标网页中匹配信息形成table-->返回index.html和phone_img_ling.csv两个文件

p=`pwd`
index=1
for page in *.html; do
	# grep一次过滤多个形成一个临时结果
	grep 'class="name"\|class="phone"\|class="detail-title"' $page -A 1 > /tmp/$$.tdcell

	h1=`cat /tmp/$$.tdcell | sed -n '1p' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}'`
	name=`cat /tmp/$$.tdcell | sed -n '5p' | sed 's/\t//g'`
	# 提取img标签中的URL技巧
	tel_img=`cat /tmp/$$.tdcell | sed -n '7p' | egrep -o '<img src=[^>]*>' | sed 's/<img src=\"\([^"]*\).*/\1/g'`

	tel_img_name=`echo $page | awk -F '.' '{print $1".png"}'`	#$page=418738.html  结果tel_img_name=418738.png
	echo $tel_img,$page >> phone-img-link.csv	#生成图片链接和图片名对应的csv格式的文件
	echo "<tr><td>$index</td><td><strong>$name</strong></td><td><img src=\"img/$tel_img_name\"></td><td>$h1</td></tr>" >> /tmp/$$.table
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
tr:hover:not(#firstrow) { font-size:4rem;background-color: purple; box-shadow: 0px 3px 7px rgba(0, 0, 0, 0.5);}
tr:hover:not(#firstrow) td:nth-child(3) { background-color:#fff}
tr:hover:not(#firstrow) td { font-weight:400;color:#fff;}
tr>td:last-child{max-width:450px;max-height: 50px;overflow: hidden; }
.mask{color: transparent;text-shadow: 0 0 3px #000;}
img{width:100px;height:20px;}
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
	<h1>家教-xianyang.liebiao-com/jiajiao/</h1>

<table id="racetimes">
<tr id="firstrow">
      <th>ID</th>
      <th>联系人</th>
      <th>电话</th>
      <th>学科</th>
  </tr>
EOF
cat /tmp/$$.table >> index.html
cat <<EOF >>index.html
</table>
</body>
</html>
EOF