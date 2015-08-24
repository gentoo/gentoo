# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

DESCRIPTION="Gnulib is a library of common routines intended to be shared at the source level"
HOMEPAGE="https://www.gnu.org/software/gnulib"

EGIT_REPO_URI="
	git://git.savannah.gnu.org/${PN}.git
	http://git.savannah.gnu.org/r/${PN}.git
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

src_compile() {
	if use doc; then
		emake -C doc info html
	fi
}

src_install() {
	dodoc README ChangeLog

	insinto /usr/share/${PN}
	doins -r build-aux
	doins -r doc
	doins -r lib
	doins -r m4
	doins -r modules
	doins -r tests
	doins -r top

	# install the real script
	exeinto /usr/share/${PN}
	doexe gnulib-tool

	# create and install the wrapper
	dosym /usr/share/${PN}/gnulib-tool /usr/bin/gnulib-tool
}
