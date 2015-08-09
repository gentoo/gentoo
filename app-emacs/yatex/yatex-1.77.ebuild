# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp eutils

DESCRIPTION="Yet Another TeX mode for Emacs"
HOMEPAGE="http://www.yatex.org/"
SRC_URI="http://www.yatex.org/${P/-/}.tar.gz"

KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="0"
LICENSE="YaTeX"
IUSE="linguas_ja"

S="${WORKDIR}/${P/-/}"
ELISP_PATCHES="${PN}-1.76-gentoo.patch
	${PN}-1.76-direntry.patch
	${PN}-1.77-texinfo-5.patch"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	# byte-compilation fails (as of 1.74): yatexlib.el requires fonts
	# that are only available under X

	cd docs
	makeinfo yatexe.tex yahtmle.tex || die

	if use linguas_ja; then
		iconv -f WINDOWS-31J -t UTF-8 yatexj.tex >yatex-ja.texi || die
		iconv -f WINDOWS-31J -t UTF-8 yahtmlj.tex >yahtml-ja.texi || die
		makeinfo yatex-ja.texi yahtml-ja.texi || die
	fi
}

src_install() {
	elisp-install ${PN} *.el || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die

	insinto ${SITEETC}/${PN}
	doins help/YATEXHLP.eng
	doinfo docs/yatex.info* docs/yahtml.info*
	dodoc docs/*.eng

	if use linguas_ja; then
		doins help/YATEXHLP.jp
		doinfo docs/yatex-ja.info* docs/yahtml-ja.info*
		dodoc 00readme install docs/{htmlqa,qanda} docs/*.doc
	fi
}
