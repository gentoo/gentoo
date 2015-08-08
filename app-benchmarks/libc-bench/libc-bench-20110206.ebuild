# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Time and memory-efficiency tests of various C/POSIX standard library functions"
HOMEPAGE="http://www.etalabs.net/libc-bench.html http://git.musl-libc.org/cgit/libc-bench/"
SRC_URI="http://www.etalabs.net/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/respect-flags.patch
}

src_configure() {
	tc-export CC
	CFLAGS+=" ${CPPFLAGS}"
}

src_install() {
	dobin libc-bench
}
