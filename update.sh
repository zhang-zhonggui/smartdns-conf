#!/bin/bash

# 定义最终输出的文件名
OUTPUT="smartdns_ad_block.conf"

echo "开始下载规则列表..."

# 【改动1】：全部替换为源仓库的 GitHub Raw 链接，彻底绕过原网站的 Cloudflare 盾和防盗链！
curl -sL "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf" -o anti-ad.conf
curl -sL "https://raw.githubusercontent.com/Cats-Team/AdRules/main/smart-dns.conf" -o adrules.conf
curl -sL "https://raw.githubusercontent.com/neodevpro/neodevhost/master/lite_smartdns.conf" -o neodevhost.conf

echo "下载完成，开始合并、去重与严格过滤..."

# 【改动2】：增加严格过滤 grep -E "^(address|nameserver)"
# 只有以 address 或 nameserver 开头的行才会被保留，即使下载失败返回 HTML 或 404，也会被直接扔掉，保证配置文件 100% 绝对安全！
cat anti-ad.conf adrules.conf neodevhost.conf | sed 's/\r//' | grep -E "^(address|nameserver)" | sort -u > $OUTPUT

# 在文件开头添加更新时间戳和说明
sed -i "1i # 更新时间: $(date '+%Y-%m-%d %H:%M:%S')" $OUTPUT
sed -i "1i # 聚合规则包含: anti-AD, adrules, neodevhost" $OUTPUT

# 清理临时文件
rm anti-ad.conf adrules.conf neodevhost.conf

echo "聚合完毕！"
