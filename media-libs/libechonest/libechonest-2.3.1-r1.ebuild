# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils multibuild

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/lfranchi/libechonest.git"
	inherit git-r3
else
	SRC_URI="http://files.lfranchi.com/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="https://projects.kde.org/projects/playground/libs/libechonest"

LICENSE="GPL-2"
SLOT="0/2.3"
IUSE="+qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RESTRICT="test" # Networking required

RDEPEND="
	qt4? (
		>=dev-libs/qjson-0.5[qt4(+)]
		dev-qt/qtcore:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS README TODO )

PATCHES=( "${FILESDIR}"/${P}-Don-t-double-encode-on-Qt4.patch )

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
