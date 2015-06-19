# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/double-conversion/double-conversion-2.0.1.ebuild,v 1.1 2014/04/02 22:54:52 bicatali Exp $

EAPI=5

inherit scons-utils eutils

DESCRIPTION="Binary-decimal and decimal-binary routines forIEEE doubles"
HOMEPAGE="http://code.google.com/p/double-conversion/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

LIBNAME=lib${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-scons.patch
}

src_compile() {
	escons ${LIBNAME}.so
	use static-libs && escons ${LIBNAME}.a
}

src_test() {
	escons run_tests
	export LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH}"
	./run_tests --list | tr -d '<' | xargs ./run_tests || die
}

src_install() {
	dolib.so ${LIBNAME}.so*
	use static-libs && dolib.a ${LIBNAME}.a
	insinto /usr/include/double-conversion
	doins src/{double-conversion,utils}.h
	dodoc README Changelog AUTHORS
}
