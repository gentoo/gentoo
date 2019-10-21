# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc opus +speex test theora vpx"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	vpx? ( media-libs/libvpx:= )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	doc? ( app-doc/doxygen )
"

src_prepare() {
	# requires network connection, bug #623708
	sed -e "/qxmppiceconnection/d" \
		-i tests/CMakeLists.txt || die "failed to drop single test"
	sed -e "/qxmppserver/d" \
		-i tests/CMakeLists.txt || die "failed to drop single test"
	sed -e "/qxmpptransfermanager/d" \
		-i tests/CMakeLists.txt || die "failed to drop single test"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=$(usex test)
		-DWITH_OPUS=$(usex opus)
		-DWITH_SPEEX=$(usex speex)
		-DWITH_THEORA=$(usex theora)
		-DWITH_VPX=$(usex vpx)
	)

	cmake-utils_src_configure
}
