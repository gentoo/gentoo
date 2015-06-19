# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/aften/aften-0.0.8.ebuild,v 1.7 2013/06/01 23:42:47 radhermit Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="An A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="cxx"

PATCHES=(
	"${FILESDIR}/${P}-multilib.patch"
	"${FILESDIR}/${P}-ppc.patch"
)

src_configure() {
	local mycmakeargs="-DSHARED=1"
	use cxx && mycmakeargs+=" -DBINDINGS_CXX=1"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README Changelog
	# File collision with media-sound/wavbreaker, upstream informed
	mv "${D}/usr/bin/wavinfo" "${D}/usr/bin/wavinfo-aften" || die
}
