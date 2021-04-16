# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Network printer command-line adminstration tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://npadmin.sourceforge.net/"

# this does NOT link against SNMP
DEPEND=""

KEYWORDS="amd64 ~ppc x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${P}-stdlib.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_install() {
	dobin npadmin
	doman npadmin.1
	dodoc README AUTHORS ChangeLog INSTALL NEWS README TODO
}
