# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils multibuild

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="https://projects.kde.org/projects/playground/libs/libechonest"
SRC_URI="http://files.lfranchi.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/2.3"
KEYWORDS="~amd64 ~x86"
IUSE="+qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RESTRICT="test" # Networking required

RDEPEND="
	qt4? (
		dev-libs/qjson[qt4(+)]
		dev-qt/qtcore:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DECHONEST_BUILD_TESTS=OFF
		)

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(-DBUILD_WITH_QT4=ON)
		fi

		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(-DBUILD_WITH_QT4=OFF)
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
