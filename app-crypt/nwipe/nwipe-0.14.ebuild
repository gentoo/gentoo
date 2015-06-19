# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/nwipe/nwipe-0.14.ebuild,v 1.1 2013/02/22 23:13:27 chutzpah Exp $

EAPI=5

DESCRIPTION="Securely erase disks using a variety of recognized methods"
HOMEPAGE="http://sourceforge.net/projects/nwipe/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-block/parted-2.3
	>=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README"
