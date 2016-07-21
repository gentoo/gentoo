# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit scons-utils eutils

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~mips ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

S="${WORKDIR}"

LIBNAME=lib${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-scons.patch
}

src_compile() {
	escons ${LIBNAME}.so.1
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
