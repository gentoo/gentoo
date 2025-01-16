# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="hfsplus_${PV}"

DESCRIPTION="HFS+ Filesystem Access Utilities (a PPC filesystem)"
HOMEPAGE="http://penguinppc.org/historical/hfsplus/"
SRC_URI="http://penguinppc.org/historical/hfsplus/${MY_P}.src.tar.bz2"
S="${WORKDIR}/hfsplus-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~loong ppc ppc64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-glob.patch
	"${FILESDIR}"/${P}-errno.patch
	"${FILESDIR}"/${P}-gcc4.patch
	"${FILESDIR}"/${P}-string.patch
	"${FILESDIR}"/${P}-stdlib.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-fno-common-gcc10.patch
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-Wincompatible-pointer-types.patch
)

src_prepare() {
	default

	# let's avoid the Makefile.cvs since it isn't working for us
	eautoreconf
}

src_configure() {
	# brittle codebase with lots of type punning, breaks LTO (#863902)
	append-cflags -fno-strict-aliasing
	# breaks w/ C23 dropping unprototyped funcs
	append-cflags -std=gnu17

	default
}

src_install() {
	default
	newman doc/man/hfsp.man hfsp.1

	find "${ED}" -name '*.la' -delete || die
}
