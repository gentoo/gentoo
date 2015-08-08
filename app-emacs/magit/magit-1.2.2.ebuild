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
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="contrib"
RESTRICT="test"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	# The upstream build system ignores errors during byte-compilation
	# and happily installs broken files, causing errors at runtime.
	# Call elisp-compile, in order to catch them here already.
	elisp-compile *.el
	emake core docs
	use contrib && emake contrib
	rm 50magit.el magit-pkg.el || die
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo magit.info
	dodoc README.md

	if use contrib; then
		elisp-install ${PN} contrib/*.{el,elc}
		dobin contrib/magit
	fi
}
