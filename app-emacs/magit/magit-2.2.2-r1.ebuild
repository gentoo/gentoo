# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode for GIT"
HOMEPAGE="http://magit.github.io/"
SRC_URI="https://github.com/magit/magit/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

SITEFILE="50${PN}-gentoo.el"

DEPEND=">=app-emacs/dash-2.12.0"
RDEPEND="${DEPEND} >=dev-vcs/git-1.9.4"

src_compile() {
	# The upstream build system ignores errors during byte-compilation
	# and happily installs broken files, causing errors at runtime.
	# Call elisp-compile, in order to catch them here already.
	elisp-compile lisp/*.el
	makeinfo Documentation/*.texi || die
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo *.info
	dodoc README.md Documentation/AUTHORS.md Documentation/${PV}.txt
}
