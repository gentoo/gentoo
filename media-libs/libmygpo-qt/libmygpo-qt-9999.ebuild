# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils multibuild

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="http://wiki.gpodder.org/wiki/Libmygpo-qt"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gpodder/libmygpo-qt.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/gpodder/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+qt4 qt5 test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-libs/qjson
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( qt4? ( dev-qt/qttest:4 ) )
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_prepare() {
	cmake-utils_src_prepare

	if ! use test ; then
		sed -i -e '/find_package/s/QtTest//' CMakeLists.txt || die
	fi
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(
				-DBUILD_WITH_QT4=ON
				-DMYGPO_BUILD_TESTS=$(usex test)
			)
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(
				-DBUILD_WITH_QT4=OFF
				-DMYGPO_BUILD_TESTS=OFF
			)
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			cmake-utils_src_test
		fi
	}
	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
