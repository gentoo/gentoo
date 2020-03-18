# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_TAG="b451121ab45497e78cb6f612c8673a9705193391"

DESCRIPTION="Library of common routines intended to be shared"
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
