# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic versionator toolchain-funcs

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://rime.im/"
SRC_URI="http://dl.bintray.com/lotem/rime/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="static-libs test"

RDEPEND="app-i18n/opencc
	dev-cpp/glog
	>=dev-cpp/yaml-cpp-0.5.0
	dev-db/kyotocabinet
	dev-libs/marisa
	>=dev-libs/boost-1.61.0-r100:=[threads(+)]
	sys-libs/zlib
	x11-proto/xproto"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}"

#bug 496080, backport patch for <gcc-4.8
PATCHES=(
	"${FILESDIR}/${PN}-1.2-BOOST_NO_SCOPED_ENUMS.patch"
	"${FILESDIR}/${PN}-1.1-gcc53613.patch"
)

src_configure() {
	# build with C++11 due to dev-libs/boost ABI switch. Do _NOT_
	# remove this, unless the build system enables C++11 by itself.
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DBUILD_STATIC=$(usex static-libs)
		-DBUILD_DATA=OFF
		-DBUILD_SEPARATE_LIBS=OFF
		-DBUILD_TEST=$(usex test)
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
