#!/bin/bash

# 生成 SmartDNS 国内域名分流列表 (chinalist.txt)
# 数据源: felixonmars/dnsmasq-china-list + 自定义 mylist.txt

OUTPUT="chinalist.txt"

echo "开始下载国内域名分流列表..."

# 下载官方源文件
curl -sL "https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf" -o raw.conf

# 提取纯域名 (从 dnsmasq 格式 server=/domain/114.114.114.114 中提取)
awk -F/ '/^server=\// {print $2}' raw.conf > temp_official.txt

# 合并自定义列表并去重
if [ -f "mylist.txt" ]; then
  echo "检测到 mylist.txt，正在合并..."
  cat temp_official.txt mylist.txt | sort -u > $OUTPUT
else
  echo "未检测到 mylist.txt，仅生成官方列表..."
  sort -u temp_official.txt > $OUTPUT
fi

# 在文件开头添加更新时间戳和说明
sed -i "1i # 更新时间: $(date '+%Y-%m-%d %H:%M:%S')" $OUTPUT
sed -i "1i # 数据源: felixonmars/dnsmasq-china-list + mylist.txt" $OUTPUT

# 清理临时文件
rm -f raw.conf temp_official.txt

echo "chinalist 生成完毕！共 $(wc -l < $OUTPUT) 条域名"
