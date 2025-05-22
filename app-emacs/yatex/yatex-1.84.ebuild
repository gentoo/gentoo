# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Yet Another TeX mode for Emacs"
HOMEPAGE="http://www.yatex.org/"
SRC_URI="http://www.${PN}.org/${P/-}.tar.gz"
S="${WORKDIR}/${P/-}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="l10n_ja"

BDEPEND="
	l10n_ja? ( virtual/libiconv )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.76-direntry.patch"
	"${FILESDIR}/${PN}-1.80-texinfo-5.patch"
	"${FILESDIR}/${PN}-1.82-texinfo.patch"
)

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i "/(help-dir/,/)))/c\      (help-dir \"${SITEETC}/${PN}\"))" "${PN}hlp.el"

	elisp_src_prepare
}

src_compile() {
	cd docs
	makeinfo {${PN},yahtml}e.tex || die

	if use l10n_ja; then
		iconv -f WINDOWS-31J -t UTF-8 "${PN}j.tex" > "${PN}-ja.texi" || die
		iconv -f WINDOWS-31J -t UTF-8 yahtmlj.tex  > yahtml-ja.texi  || die
		makeinfo {${PN},yahtml}-ja.texi || die
	fi
}

src_install() {
	elisp-install "${PN}" ./*.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins help/YATEXHLP.eng
	doinfo docs/{${PN},yahtml}.info*
	dodoc install docs/*.eng

	if use l10n_ja; then
		doins help/YATEXHLP.jp
		doinfo docs/{${PN},yahtml}-ja.info*
		dodoc 00readme "${PN}.new" docs/{htmlqa,qanda,*.doc}
	fi
}
