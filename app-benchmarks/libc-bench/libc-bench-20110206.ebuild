# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/libc-bench/libc-bench-20110206.ebuild,v 1.2 2014/04/03 20:58:19 vapier Exp $

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
