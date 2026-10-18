# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langchinese.r79450
	arphic.r15878
	arphic-ttf.r42675
	cns.r45677
	exam-zh.r79661
	fandol.r37889
	fduthesis.r67231
	gbt9704.r79600
	hanzibox.r79715
	hyphen-chinese.r78069
	luatex-cn.r78192
	lxgw-fonts.r79609
	nanicolle.r56224
	njurepo.r50492
	pgfornament-han.r72640
	qyxf-book.r75712
	sjtutex.r78164
	suanpan-l3.r76924
	upzhkinsoku.r47354
	xpinyin.r79618
	xtuthesis.r47049
	zhlineskip.r79618
	zhlipsum.r79461
	zhmetrics.r79618
	zhmetrics-uptex.r40728
	zhnumber.r79618
	zhspacing.r79618
"
TEXLIVE_MODULE_SRC_CONTENTS="
	arphic.doc.r15878
	arphic-ttf.doc.r42675
	asymptote-by-example-zh-cn.doc.r15878
	asymptote-faq-zh-cn.doc.r15878
	asymptote-manual-zh-cn.doc.r15878
	cns.doc.r45677
	exam-zh.doc.r79661
	fandol.doc.r37889
	fduthesis.doc.r67231
	gbt9704.doc.r79600
	hanzibox.doc.r79715
	impatient-cn.doc.r54080
	install-latex-guide-zh-cn.doc.r79570
	latex-notes-zh-cn.doc.r15878
	lshort-chinese.doc.r73160
	luatex-cn.doc.r78192
	lxgw-fonts.doc.r79609
	nanicolle.doc.r56224
	njurepo.doc.r50492
	pgfornament-han.doc.r72640
	qyxf-book.doc.r75712
	sjtutex.doc.r78164
	suanpan-l3.doc.r76924
	texlive-zh-cn.doc.r78073
	texproposal.doc.r43151
	tlmgr-intro-zh-cn.doc.r59100
	upzhkinsoku.doc.r47354
	xpinyin.doc.r79618
	xtuthesis.doc.r47049
	zhlineskip.doc.r79618
	zhlipsum.doc.r79461
	zhmetrics.doc.r79618
	zhmetrics-uptex.doc.r40728
	zhnumber.doc.r79618
	zhspacing.doc.r79618
"
TEXLIVE_MODULE_DOC_CONTENTS="
	fduthesis.source.r67231
	hanzibox.source.r79715
	lxgw-fonts.source.r79609
	njurepo.source.r50492
	sjtutex.source.r78164
	xpinyin.source.r79618
	zhlineskip.source.r79618
	zhlipsum.source.r79461
	zhmetrics.source.r79618
	zhnumber.source.r79618
"

inherit texlive-module

DESCRIPTION="TeXLive Chinese"

LICENSE="Apache-2.0 FDL-1.1+ GPL-1+ GPL-3+ LGPL-2+ LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-langcjk-2026
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

# Avoids collision with app-text/ttf2pk2
src_prepare() {
	default
	local i=texmf-dist/source/fonts/zhmetrics/ttfonts.map
	if [[ -f "${i}" ]]; then
		rm -f "${i}" || die
	fi
}
