# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/nwipe/nwipe-0.12.ebuild,v 1.1 2012/11/30 14:16:01 ssuominen Exp $

EAPI=5

inherit autotools

DESCRIPTION="Securely erase disks using a variety of recognized methods"
HOMEPAGE="http://sourceforge.net/projects/nwipe/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-block/parted-2.3
	>=sys-libs/ncurses-5.7-r7"
DEPEND=${RDEPEND}

DOCS="README"

src_prepare() { eautoreconf; } # prevent maintainer mode
