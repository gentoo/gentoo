# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

QT_MINIMAL="4.8.0"
inherit cmake-utils

DESCRIPTION="A Qt C++ library for the Last.fm webservices"
HOMEPAGE="https://github.com/lastfm/liblastfm"
SRC_URI="https://github.com/lastfm/liblastfm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="fingerprint test"

COMMON_DEPEND="
	>=dev-qt/qtcore-${QT_MINIMAL}:4
	>=dev-qt/qtdbus-${QT_MINIMAL}:4
	fingerprint? (
		media-libs/libsamplerate
		sci-libs/fftw:3.0
		>=dev-qt/qtsql-${QT_MINIMAL}:4
	)
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qttest-${QT_MINIMAL}:4 )
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/lastfmlib-0.4.0
"

# 1 of 2 is failing, last checked version 1.0.7
RESTRICT="test"

src_configure() {
	# demos not working
	# qt5 support broken
	local mycmakeargs=(
		-DBUILD_DEMOS=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Core=ON
		-DBUILD_WITH_QT4=ON
		$(cmake-utils_use_build fingerprint)
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}
