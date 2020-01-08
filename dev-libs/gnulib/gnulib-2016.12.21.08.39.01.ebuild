# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_TAG="3a0b7b74982f44c735f4cfc2dccf538c3c4ef9e2"

DESCRIPTION="Gnulib is a library of common routines intended to be shared at the source level"
HOMEPAGE="https://www.gnu.org/software/gnulib"
SRC_URI="https://git.savannah.gnu.org/cgit/${PN}.git/snapshot/${PN}-${GIT_TAG}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

S="${WORKDIR}/${PN}-${GIT_TAG}"

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
