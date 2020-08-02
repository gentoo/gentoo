# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"
EGIT_REPO_URI="https://github.com/qxmpp-project/qxmpp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc opus +speex test theora vpx"
RESTRICT="!test? ( test )"

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
	sed \
		-e "/qxmppiceconnection/d" \
		-e "/qxmppserver/d" \
		-e "/qxmpptransfermanager/d" \
		-i tests/CMakeLists.txt \
		|| die "failed to drop certain network tests"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=$(usex test)
		-DBUILD_INTERNAL_TESTS=$(usex test)
		-DWITH_OPUS=$(usex opus)
		-DWITH_SPEEX=$(usex speex)
		-DWITH_THEORA=$(usex theora)
		-DWITH_VPX=$(usex vpx)
	)

	cmake_src_configure
}
