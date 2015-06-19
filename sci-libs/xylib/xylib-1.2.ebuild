# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/xylib/xylib-1.2.ebuild,v 1.1 2013/08/12 20:55:18 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Experimental x-y data reading library"
HOMEPAGE="http://www.unipress.waw.pl/fityk/xylib/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 static-libs zlib"

RDEPEND="
	dev-libs/boost
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_with bzip2 bzlib)
		$(use_with zlib)
	)
	autotools-utils_src_configure
}
