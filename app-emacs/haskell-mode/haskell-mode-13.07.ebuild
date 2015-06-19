# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/haskell-mode/haskell-mode-13.07.ebuild,v 1.5 2014/04/13 16:25:34 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="Mode for editing (and running) Haskell programs in Emacs"
HOMEPAGE="http://projects.haskell.org/haskellmode-emacs/
	http://www.haskell.org/haskellwiki/Emacs#Haskell-mode"
SRC_URI="https://github.com/haskell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="haskell-mode.texi"
DOCS="NEWS README.md examples/*.hs examples/init.el"

src_prepare() {
	# We install the logo in SITEETC, not in SITELISP
	# https://github.com/haskell/haskell-mode/issues/102
	sed -i -e "/defconst haskell-process-logo/{n;" \
		-e "s:(.*\"\\(.*\\)\".*):\"${SITEETC}/${PN}/\\1\":}" \
		haskell-process.el || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file haskell-site-file.el
}

src_test() {
	# perform tests in a separate directory #504660
	mkdir test && cp *.el Makefile test || die
	emake -C test check
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins logo.svg
}
