# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="https://projects.kde.org/projects/playground/libs/libechonest"
SRC_URI="http://files.lfranchi.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/2.2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test" # Networking required

RDEPEND=">=dev-libs/qjson-0.5
	dev-qt/qtcore:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )

PATCHES=( "${FILESDIR}"/${P}-always_use_QJSON_LIBRARIES.patch )

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e '/find_package/s/QtTest//' CMakeLists.txt || die #507086
}

src_configure() {
	local mycmakeargs=(
		-DECHONEST_BUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}
