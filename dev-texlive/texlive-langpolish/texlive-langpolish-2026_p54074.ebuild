# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langpolish.r54074
	babel-polish.r77682
	bredzenie.r44371
	cc-pl.r58602
	gustlib.r54074
	hyphen-polish.r78069
	mex.r58661
	mwcls.r77050
	pl.r58661
	polski.r78101
	przechlewski-book.r23552
	qpxqtx.r45797
	tap.r31731
	utf8mex.r15878
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-polish.doc.r77682
	bredzenie.doc.r44371
	cc-pl.doc.r58602
	gustlib.doc.r54074
	gustprog.doc.r54074
	lshort-polish.doc.r63289
	mex.doc.r58661
	mwcls.doc.r77050
	pl.doc.r58661
	polski.doc.r78101
	przechlewski-book.doc.r23552
	qpxqtx.doc.r45797
	tap.doc.r31731
	tex-virtual-academy-pl.doc.r67718
	texlive-pl.doc.r78337
	utf8mex.doc.r15878
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-polish.source.r77682
	mex.source.r58661
	mwcls.source.r77050
	polski.source.r78101
"

inherit texlive-module

DESCRIPTION="TeXLive Polish"

LICENSE="FDL-1.1+ GPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c TeX public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
	>=dev-texlive/texlive-latex-2026
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
