# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network printer command-line administration tool"
HOMEPAGE="https://npadmin.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

# this does NOT link against SNMP
# DEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-stdlib.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin npadmin
	doman npadmin.1
	dodoc README AUTHORS ChangeLog INSTALL NEWS README TODO
}
