# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit elisp

DESCRIPTION="Yet Another TeX mode for Emacs"
HOMEPAGE="http://www.yatex.org/"
SRC_URI="http://www.${PN}.org/${P/-}.tar.gz"

KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="0"
LICENSE="YaTeX"
IUSE="l10n_ja"

S="${WORKDIR}/${P/-}"

ELISP_PATCHES="${PN}-1.76-gentoo.patch
	${PN}-1.76-direntry.patch
	${PN}-1.77-texinfo-5.patch"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	# byte-compilation fails (as of 1.74): yatexlib.el requires fonts
	# that are only available under X

	cd docs
	makeinfo {${PN},yahtml}e.tex || die

	if use l10n_ja; then
		iconv -f WINDOWS-31J -t UTF-8 ${PN}j.tex  > ${PN}-ja.texi  || die
		iconv -f WINDOWS-31J -t UTF-8 yahtmlj.tex > yahtml-ja.texi || die
		makeinfo {${PN},yahtml}-ja.texi || die
	fi
}

src_install() {
	elisp-install ${PN} *.el
	elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	insinto ${SITEETC}/${PN}
	doins help/YATEXHLP.eng
	doinfo docs/{${PN},yahtml}.info*
	dodoc docs/*.eng

	if use l10n_ja; then
		doins help/YATEXHLP.jp
		doinfo docs/{${PN},yahtml}-ja.info*
		dodoc 00readme install docs/{htmlqa,qanda,*.doc}
	fi
}
