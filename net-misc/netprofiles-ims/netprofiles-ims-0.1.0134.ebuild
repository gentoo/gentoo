# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Netprofiles Interface Management System manages network configurations"

HOMEPAGE="http://www.furuba.net/~buckminst/gentoo/"
SRC_URI="http://www.furuba.net/~buckminst/gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_install() {
	dosbin netprofiles
	doinitd netprofiles-ims
}
