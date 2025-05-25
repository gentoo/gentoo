# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++/Boost Asio based websocket client/server library"
HOMEPAGE="https://www.zaphoyd.com/websocketpp"
SRC_URI="
	https://github.com/zaphoyd/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~sbraz/${P}-boost-1.87-compat.patch.xz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/boost )"
RDEPEND="dev-libs/boost"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-cmake-install.patch
	# disable tests that are timing sensitive
	# https://bugzilla.redhat.com/show_bug.cgi?id=1461069
	"${FILESDIR}"/${PN}-0.8.1-disable-test_transport-test_transport_asio_timers.patch
	# https://github.com/zaphoyd/websocketpp/commit/36b73da8958927f975b3d01a062aa6c0e149d97f
	"${FILESDIR}"/${P}-fix-boost_find_component.patch
	# https://github.com/zaphoyd/websocketpp/commit/2c355d9ef0f3ed73fa96d0c6c31293086df36d74
	"${FILESDIR}"/${P}-fix-clang.patch
	# C++20 support from https://github.com/zaphoyd/websocketpp/commit/3197a520eb4c1e4754860441918a5930160373eb
	# Fixes https://github.com/zaphoyd/websocketpp/issues/991 / https://bugs.gentoo.org/939739
	"${FILESDIR}/${P}-c++20-compat.patch"
	# From https://github.com/zaphoyd/websocketpp/pull/1164
	"${WORKDIR}/${P}-boost-1.87-compat.patch"
	# https://github.com/zaphoyd/websocketpp/commit/deb0a334471362608958ce59a6b0bcd3e5b73c24
	"${FILESDIR}/${P}-cmake4.patch" # bug 953936
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CPP11=ON
		-DBUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
