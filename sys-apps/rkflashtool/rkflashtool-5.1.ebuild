# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rkflashtool/rkflashtool-5.1.ebuild,v 1.1 2014/01/08 04:43:34 mrueg Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Tool for flashing Rockchip devices"
HOMEPAGE="http://sourceforge.net/projects/rkflashtool/"
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
