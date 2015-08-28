# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="A DropDrawers clone. Multiple information organizer"
HOMEPAGE="http://basket.kde.org/"
SRC_URI="http://${PN}.kde.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug crypt"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	media-libs/qimageblitz
	x11-libs/libX11
	crypt? ( >=app-crypt/gpgme-1.0 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package crypt Gpgme)
	)
	kde4-base_src_configure
}
