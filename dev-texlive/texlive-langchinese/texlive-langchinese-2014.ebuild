# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langchinese/texlive-langchinese-2014.ebuild,v 1.4 2015/07/22 19:37:40 blueness Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="arphic asymptote-by-example-zh-cn asymptote-faq-zh-cn asymptote-manual-zh-cn cns ctex ctex-faq fandol hyphen-chinese latex-notes-zh-cn lshort-chinese texlive-zh-cn xpinyin zhmetrics zhnumber zhspacing collection-langchinese
"
TEXLIVE_MODULE_DOC_CONTENTS="arphic.doc asymptote-by-example-zh-cn.doc asymptote-faq-zh-cn.doc asymptote-manual-zh-cn.doc cns.doc ctex.doc ctex-faq.doc fandol.doc latex-notes-zh-cn.doc lshort-chinese.doc texlive-zh-cn.doc xpinyin.doc zhmetrics.doc zhnumber.doc zhspacing.doc "
TEXLIVE_MODULE_SRC_CONTENTS="xpinyin.source zhmetrics.source zhnumber.source "
inherit  texlive-module
DESCRIPTION="TeXLive Chinese"

LICENSE=" FDL-1.1 GPL-1 GPL-2 LGPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2014
!<dev-texlive/texlive-langcjk-2014
"
RDEPEND="${DEPEND} "
# Avoids collision with app-text/ttf2pk2
src_prepare() {
	local i=texmf-dist/source/fonts/zhmetrics/ttfonts.map
	[ -f "${i}" ] && rm -f "${i}"
}
