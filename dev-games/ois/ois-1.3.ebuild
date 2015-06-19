# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/ois/ois-1.3.ebuild,v 1.7 2015/04/02 16:53:58 aballier Exp $

EAPI=4
inherit autotools autotools-utils

MY_P=${PN}-v${PV/./-}
DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="http://sourceforge.net/projects/wgois/"
SRC_URI="mirror://sourceforge/wgois/${MY_P/-/_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="static-libs"

DEPEND="x11-libs/libXaw
	x11-libs/libX11"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-automake-1.13.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	autotools-utils_src_configure

}
