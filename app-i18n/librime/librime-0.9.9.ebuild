# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://rime.im/"
SRC_URI="https://rimeime.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="static-libs test"

RDEPEND="app-i18n/opencc
	dev-cpp/glog
	>=dev-cpp/yaml-cpp-0.5.0
	dev-db/kyotocabinet
	>=dev-libs/boost-1.46.0[threads(+)]
	sys-libs/zlib
	x11-proto/xproto"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-test.patch"
	"${FILESDIR}/${PN}-dictionary.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC)
		-DBUILD_DATA=OFF
		$(cmake-utils_use_build test TEST)
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
