# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib versionator vcs-snapshot toolchain-funcs

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://rime.im/"
SRC_URI="https://github.com/rime/${PN}/archive/rime-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="static-libs test"

RDEPEND=">app-i18n/opencc-1.0.2
	dev-cpp/glog
	>=dev-cpp/yaml-cpp-0.5.0
	dev-db/kyotocabinet
	dev-libs/leveldb
	dev-libs/marisa
	>=dev-libs/boost-1.46.0[threads(+)]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	x11-proto/xproto
	test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC)
		-DBUILD_DATA=OFF
		-DBUILD_SEPARATE_LIBS=OFF
		$(cmake-utils_use_build test TEST)
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
