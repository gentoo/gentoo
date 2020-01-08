# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic qmake-utils

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake-utils_src_prepare
	if ! use static-libs ; then
		sed -e "/^install/ s/quazip_static//" -i quazip/CMakeLists.txt || die
	fi
}

src_configure() {
	local libdir=$(get_libdir)
	local -x CXXFLAGS="${CXXFLAGS}"
	append-cxxflags -std=c++11 -fPIC

	local mycmakeargs=(
		-DBUILD_WITH_QT4=OFF
		-DLIB_SUFFIX=${libdir/lib/}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# compatibility with not yet fixed rdeps (Gentoo bug #598136)
	dosym libquazip5.so /usr/$(get_libdir)/libquazip.so
}
