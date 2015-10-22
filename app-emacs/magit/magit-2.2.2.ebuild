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
IUSE="contrib"
RESTRICT="test"

SITEFILE="50${PN}-gentoo.el"

CDEPEND=">=app-emacs/dash-2.12.0"

DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND} >=dev-vcs/git-1.9.4"

src_prepare() {
	# Makefile expects this to be present at the current directory
	ln -s lisp/magit-version.el magit-version.el || die
}

src_compile() {
	# The upstream build system ignores errors during byte-compilation
	# and happily installs broken files, causing errors at runtime.
	# Call elisp-compile, in order to catch them here already.
	pushd lisp || die
	elisp-compile *.el
	popd || die
	emake docs
	use contrib && emake contrib
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo Documentation/*.info
	dodoc README.md

	if use contrib; then
		elisp-install ${PN} contrib/*.{el,elc}
		dobin contrib/magit
	fi
}
