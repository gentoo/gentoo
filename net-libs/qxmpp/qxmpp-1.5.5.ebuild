# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gstreamer omemo test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	gstreamer? ( media-libs/gstreamer )
	omemo? (
		app-crypt/qca:2[qt5(+)]
		net-libs/libomemo-c
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	doc? ( app-text/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=$(usex test)
		-DBUILD_INTERNAL_TESTS=$(usex test)
		-DBUILD_OMEMO=$(usex omemo)
		-DWITH_QCA=$(usex omemo)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DQT_VERSION_MAJOR=5
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# require network connection, bug #623708
		-E "tst_(qxmpptransfermanager|qxmppiceconnection)"
	)

	cmake_src_test
}
