# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.03
DIST_AUTHOR=AMBA
KEYWORDS="amd64 ~x86"
inherit perl-module

DESCRIPTION="Perl interface to the VXI-11 Test&Measurement backend"

SLOT="0"

RDEPEND="
	net-libs/libtirpc
"
DEPEND="${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_configure() {
	myconf=(
		OPTIMIZE="${CFLAGS} -I/usr/include/tirpc"
		LIBS="-ltirpc"
	)
	perl-module_src_configure
}
