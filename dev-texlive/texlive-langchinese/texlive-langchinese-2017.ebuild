# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="arphic arphic-ttf asymptote-by-example-zh-cn asymptote-faq-zh-cn asymptote-manual-zh-cn cns ctex ctex-faq fandol hyphen-chinese impatient-cn latex-notes-zh-cn lshort-chinese texlive-zh-cn texproposal xpinyin zhmetrics zhmetrics-uptex zhnumber zhspacing collection-langchinese
"
TEXLIVE_MODULE_DOC_CONTENTS="arphic.doc arphic-ttf.doc asymptote-by-example-zh-cn.doc asymptote-faq-zh-cn.doc asymptote-manual-zh-cn.doc cns.doc ctex.doc ctex-faq.doc fandol.doc impatient-cn.doc latex-notes-zh-cn.doc lshort-chinese.doc texlive-zh-cn.doc texproposal.doc xpinyin.doc zhmetrics.doc zhmetrics-uptex.doc zhnumber.doc zhspacing.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ctex.source xpinyin.source zhmetrics.source zhnumber.source "
inherit  texlive-module
DESCRIPTION="TeXLive Chinese"

LICENSE=" FDL-1.1 GPL-1 GPL-2 LGPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2017
!<dev-texlive/texlive-langcjk-2014
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} "
# Avoids collision with app-text/ttf2pk2
src_prepare() {
	local i=texmf-dist/source/fonts/zhmetrics/ttfonts.map
	[ -f "${i}" ] && rm -f "${i}"
}
