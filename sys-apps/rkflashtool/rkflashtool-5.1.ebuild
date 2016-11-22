# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Tool for flashing Rockchip devices"
HOMEPAGE="https://sourceforge.net/projects/rkflashtool/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}/${P}-src.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${P}-src

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

src_prepare(){
	cp "${FILESDIR}"/${P}-missing-version.h version.h || die
	sed -i -e "s/CC	=/CC ?=/"\
		-e "s/CFLAGS	=/CFLAGS ?=/"\
		-e "s/LDFLAGS	=/LDFLAGS ?=/" Makefile || die
	tc-export CC
}

src_install(){
	dodoc README
	dobin ${PN} rkcrc  rkflashtool rkmisc  rkpad  rkparameters  rkparametersblock  rkunpack  rkunsign
}
