# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic multibuild qmake-utils

DESCRIPTION="A simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="http://quazip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="qt4 +qt5 static-libs test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	sys-libs/zlib[minizip]
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
"
DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
	)
"

DOCS=( NEWS.txt README.txt )
HTML_DOCS=( doc/html/. )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_prepare() {
	if ! use static-libs ; then
		sed -e "/^install/ s/quazip_static//" -i quazip/CMakeLists.txt || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	myconfigure() {
		local libdir=$(get_libdir)
		local mycmakeargs=(
			-DLIB_SUFFIX=${libdir/lib/}
		)
		unset libdir
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DBUILD_WITH_QT4=ON )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			local -x CXXFLAGS="${CXXFLAGS}"
			append-cxxflags -std=c++11 -fPIC
			mycmakeargs+=( -DBUILD_WITH_QT4=OFF )
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	cd "${S}"/qztest || die
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			eqmake4 \
				LIBS+="-L${WORKDIR}/${P}-qt4"
			emake
			LD_LIBRARY_PATH="${WORKDIR}/${P}-qt4" ./qztest || die
		fi
	}

	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
