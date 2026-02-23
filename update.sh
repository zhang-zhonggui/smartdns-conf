#!/bin/bash

# 定义最终输出的文件名
OUTPUT="smartdns_ad_block.conf"

echo "开始下载规则列表..."

# 下载三个源文件 (使用 -sL 静默下载并跟随重定向)
curl -sL "https://anti-ad.net/anti-ad-for-smartdns.conf" -o anti-ad.conf
curl -sL "https://adrules.top/smart-dns.conf" -o adrules.conf
curl -sL "https://raw.githubusercontent.com/neodevpro/neodevhost/master/lite_smartdns.conf" -o neodevhost.conf

echo "下载完成，开始合并与去重..."

# 合并、去除 Windows 回车符(\r)、去除注释行(#)、去除空行、最后去重(sort -u)
cat anti-ad.conf adrules.conf neodevhost.conf | sed 's/\r//' | grep -v "^#" | grep -v "^$" | sort -u > $OUTPUT

# 在文件开头添加更新时间戳和说明
sed -i "1i # 更新时间: $(date '+%Y-%m-%d %H:%M:%S')" $OUTPUT
sed -i "1i # 聚合规则包含: anti-AD, adrules, neodevhost" $OUTPUT

# 清理临时文件
rm anti-ad.conf adrules.conf neodevhost.conf

echo "聚合完毕！"
