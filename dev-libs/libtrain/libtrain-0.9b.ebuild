# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtrain/libtrain-0.9b.ebuild,v 1.14 2012/07/01 10:12:22 jlec Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Library for calculating fastest train routes"
SRC_URI="http://www.on.rim.or.jp/~katamuki/software/train/${P}.tar.gz"
HOMEPAGE="http://www.on.rim.or.jp/~katamuki/software/train/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc sparc x86"
IUSE="debug static-libs "

PATCHES=( "${FILESDIR}"/${P}-impl-dec.patch )

src_configure() {
	local myeconfargs=( $(use_enable debug) )
	autotools-utils_src_configure
}
