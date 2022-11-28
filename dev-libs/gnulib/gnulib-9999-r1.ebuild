# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Gnulib is a library of common routines intended to be shared at the source level"
HOMEPAGE="https://www.gnu.org/software/gnulib"

EGIT_REPO_URI="https://git.savannah.gnu.org/r/${PN}.git"
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
	dosym ../share/${PN}/gnulib-tool /usr/bin/gnulib-tool
}
