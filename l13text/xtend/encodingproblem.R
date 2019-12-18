##  探索编码问题
##
# 编码问题：
# 北京  "\xb1\xb1\xbe\xa9\xca\xd0"  #gb2312
# 北京  '\u5317\u4eac\u5e02'  # utf-8
# 北京   "å\u008c\u0097äº¬å¸\u0082"  #latin


print('\u5317\u4eac\u5e02')

x = "\u5317\u4eac\u5e02"
r="\xb1\xb1\xbe\xa9\xca\xd0"
c="北京市"

l1="åŒ—äº¬å¸‚"
l2="å\u008c\u0097äº¬å¸\u0082"  


Encoding(l1) <- "uft-8"

l1

# 错误编码
Encoding(x) <- "latin1"
x
charToRaw(xx <- iconv(x, "latin1", "UTF-8"))
xx

# 正确编码
Encoding(x) <- "utf-8"
x

# 正确编码
Encoding(c) <- "utf-8"
c

x


charToRaw(r)

rawToChar(charToRaw(r))    

charToRaw(xx <- iconv(x, "UTF-8", "gb2312"))
xx

iconv(l, "latin1", "")


# 正确编码
Encoding(x) <- "gb2312"
x
charToRaw(xx <- iconv(x, "UTF-8", "gb2312"))
xx

rawToChar(r, multiple = FALSE)



iconv(x, "latin1", "ASCII")          #   NA
iconv(x, "latin1", "ASCII", "?")     # "fa?ile"
iconv(x, "latin1", "ASCII", "")      # "faile"
iconv(x, "latin1", "ASCII", "byte")  # "fa<e7>ile"


print(encode("gb18030").decode("gb18030"))
