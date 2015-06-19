# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/photoqt/photoqt-1.0.ebuild,v 1.1 2014/12/15 13:44:50 yngwin Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="http://photoqt.org/"
SRC_URI="http://photoqt.org/oldRel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="exiv2 graphicsmagick" # phonon"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	exiv2? ( media-gfx/exiv2:= )
	graphicsmagick? ( media-gfx/graphicsmagick:= )"
#	phonon? ( || ( media-libs/phonon dev-qt/qtphonon ) )" # fails to compile
RDEPEND="${DEPEND}"

src_prepare() {
	# make desktop file validate; needs more work
	echo ';' >> "${S}"/${PN}.desktop || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use exiv2 EXIV2)
		$(cmake-utils_use graphicsmagick GM)
		-DPHONON=OFF
		)
	cmake-utils_src_configure
}
