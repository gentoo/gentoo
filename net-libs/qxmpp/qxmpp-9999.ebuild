# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/qxmpp-project/qxmpp"

inherit git-r3 cmake-utils

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"

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
	dev-util/cmake
	test? ( dev-qt/qttest:5 )
	doc? ( app-doc/doxygen )
"

src_prepare() {
	# requires network connection, bug #623708
	sed -e "/qxmppiceconnection/d" \
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

src_install() {
	cmake-utils_src_install

	if use doc; then
		# Use proper path for documentation
		mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die "doc mv failed"
	fi
}
