# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="hfsplus_${PV}"

DESCRIPTION="HFS+ Filesystem Access Utilities (a PPC filesystem)"
HOMEPAGE="http://penguinppc.org/historical/hfsplus/"
SRC_URI="http://penguinppc.org/historical/hfsplus/${MY_P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"

S="${WORKDIR}/hfsplus-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-glob.patch
	"${FILESDIR}"/${P}-errno.patch
	"${FILESDIR}"/${P}-gcc4.patch
	"${FILESDIR}"/${P}-string.patch
	"${FILESDIR}"/${P}-stdlib.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-fno-common-gcc10.patch
	"${FILESDIR}"/${P}-gcc5.patch
)

src_prepare() {
	default

	# let's avoid the Makefile.cvs since isn't working for us
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	newman doc/man/hfsp.man hfsp.1

	find "${D}" -name '*.la' -delete || die
}
