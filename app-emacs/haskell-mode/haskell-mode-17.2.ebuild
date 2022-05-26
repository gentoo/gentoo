# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=25

inherit elisp

DESCRIPTION="Mode for editing (and running) Haskell programs in Emacs"
HOMEPAGE="https://haskell.github.io/haskell-mode/
	https://www.haskell.org/haskellwiki/Emacs#Haskell-mode"
SRC_URI="https://github.com/haskell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

BDEPEND="sys-apps/texinfo"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="doc/haskell-mode.texi"
DOCS="NEWS README.md"

src_prepare() {
	# We install the logo in SITEETC, not in SITELISP
	# https://github.com/haskell/haskell-mode/issues/102
	sed -i -e "/defconst haskell-process-logo/{n;" \
		-e "s:(.*\"\\(.*\\)\".*):\"${SITEETC}/${PN}/\\1\":}" \
		haskell-process.el || die

	eapply_user
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file haskell-site-file.el
}

src_test() {
	emake check-ert
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}"/${PN}
	doins logo.svg
}
