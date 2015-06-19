# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gnulib/gnulib-2013.10.28.22.33.52.ebuild,v 1.1 2014/12/27 20:11:22 grobian Exp $

EAPI=5

inherit eutils

GIT_TAG="0.1"

DESCRIPTION="Gnulib is a library of common routines intended to be shared at the source level"
HOMEPAGE="http://www.gnu.org/software/gnulib"
SRC_URI="http://git.savannah.gnu.org/cgit/${PN}.git/snapshot/${PN}-${GIT_TAG}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
	dosym /usr/share/${PN}/gnulib-tool /usr/bin/gnulib-tool
}
