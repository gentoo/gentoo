# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="C++/Boost Asio based websocket client/server library"
HOMEPAGE="http://www.zaphoyd.com/websocketpp"
SRC_URI="https://github.com/zaphoyd/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="boost examples test"

DEPEND=""
RDEPEND="${DEPEND}
	boost? ( dev-libs/boost )
"

# tests no-op
RESTRICT="test"

src_configure() {
	# Disable EXAMPLES as compilation is broken upstream
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use_enable !boost CPP11)
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}
