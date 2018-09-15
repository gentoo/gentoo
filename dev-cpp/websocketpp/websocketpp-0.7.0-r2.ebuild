# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++/Boost Asio based websocket client/server library"
HOMEPAGE="https://www.zaphoyd.com/websocketpp"
SRC_URI="https://github.com/zaphoyd/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="boost examples test"

DEPEND=""
RDEPEND="${DEPEND}
	boost? ( dev-libs/boost )
"

# bug 630450
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-cmake-install.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_CPP11="$(usex !boost)"
		-DBUILD_TESTS="$(usex test)"
	)

	cmake-utils_src_configure
}

src_install() {
	use examples && DOCS=( examples/ )
	cmake-utils_src_install
}
