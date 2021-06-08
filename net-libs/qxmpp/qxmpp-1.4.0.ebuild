# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gstreamer test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	gstreamer? ( media-libs/gstreamer )
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
		-DWITH_GSTREAMER=$(usex gstreamer)
	)

	cmake_src_configure
}
