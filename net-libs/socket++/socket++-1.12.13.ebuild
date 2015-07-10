# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/socket++/socket++-1.12.13.ebuild,v 1.1 2015/07/10 09:44:04 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="C++ Socket Library"
HOMEPAGE="http://www.linuxhacker.at/socketxx/"
SRC_URI="http://src.linuxhacker.at/socket++/${P}.tar.gz"

LICENSE="freedist GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~x86"

IUSE="debug static-libs"

RESTRICT="bindist"

DEPEND="sys-apps/texinfo"
RDEPEND=""

DOCS=( AUTHORS ChangeLog NEWS README README2 README3 THANKS )

PATCHES=( "${FILESDIR}/${PN}-1.12.12-gcc47.patch" )

src_prepare() {
	# bug #514246
	sed -i -e 's/@subsection t/@section t/g' doc/socket++.texi || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
