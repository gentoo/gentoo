# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake kde.org

DESCRIPTION="Cross-platform C++ XMPP client and server library"
HOMEPAGE="https://invent.kde.org/libraries/qxmpp"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/unstable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1 CC0-1.0"
SLOT="0/10"
IUSE="gstreamer omemo test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-qt/qtbase-6.11.2:6[network,ssl,xml]
	gstreamer? ( media-libs/gstreamer )
	omemo? (
		>=dev-libs/openssl-3:=
		net-libs/libomemo-c
	)
"
DEPEND="${RDEPEND}"
#	doc? (
#		dev-qt/qttools:6[qdoc]
#		kde-frameworks/extra-cmake-modules
#	)
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_ECM=ON # clang-format only
		-DBUILD_DOCUMENTATION=OFF # $(usex doc) TODO: Port to ECMGenerateQDoc
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
		-DBUILD_OMEMO=$(usex omemo)
		-DWITH_ENCRYPTION=$(usex omemo)
		-DWITH_GSTREAMER=$(usex gstreamer)
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# require network connection, bug #623708
		tst_QXmppTransferManager
		tst_QXmppIceConnection
	)
	cmake_src_test
}
