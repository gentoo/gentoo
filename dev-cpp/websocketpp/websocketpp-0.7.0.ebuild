# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
