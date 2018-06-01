# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A collection of small tools for accessing netgroup contents"
HOMEPAGE="ftp://ftp.hungry.com/pub/hungry/ng-utils"
SRC_URI="ftp://ftp.hungry.com/pub/hungry/ng-utils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
