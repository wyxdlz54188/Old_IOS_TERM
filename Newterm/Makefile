ARCHS = armv7 armv7s
TARGET = iphone:6.0:4.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Newterm

# 原有 MRC 文件
Newterm_FILES = $(filter-out MarkdownParser.m MarkdownConfiguration.m MarkdownElement.m MarkdownHeader.m MarkdownList.m MarkdownQuote.m MarkdownCode.m MarkdownLink.m MarkdownImage.m MarkdownHorizontalRule.m NSString+Markdown.m, $(wildcard *.m))

# MarkdownKit 文件使用 ARC
Newterm_FILES += MarkdownParser.m MarkdownConfiguration.m MarkdownElement.m MarkdownHeader.m MarkdownList.m MarkdownQuote.m MarkdownCode.m MarkdownLink.m MarkdownImage.m MarkdownHorizontalRule.m NSString+Markdown.m

MarkdownParser.m_CFLAGS = -fobjc-arc
MarkdownConfiguration.m_CFLAGS = -fobjc-arc
MarkdownElement.m_CFLAGS = -fobjc-arc
MarkdownHeader.m_CFLAGS = -fobjc-arc
MarkdownList.m_CFLAGS = -fobjc-arc
MarkdownQuote.m_CFLAGS = -fobjc-arc
MarkdownCode.m_CFLAGS = -fobjc-arc
MarkdownLink.m_CFLAGS = -fobjc-arc
MarkdownImage.m_CFLAGS = -fobjc-arc
MarkdownHorizontalRule.m_CFLAGS = -fobjc-arc
NSString+Markdown.m_CFLAGS = -fobjc-arc

Newterm_FRAMEWORKS = AudioToolbox CoreGraphics CoreText UIKit QuartzCore CoreFoundation
Newterm_LIBRARIES = util
Newterm_LDFLAGS = -lSystem_syms
Newterm_RESOURCE_FILES = Info.plist Icon-72.png Icon-72@2x.png
ADDITIONAL_OBJCFLAGS = -fno-objc-arc -include MTerminal_Prefix.pch -Wno-single-bit-bitfield-constant-conversion

include $(THEOS_MAKE_PATH)/application.mk