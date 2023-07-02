# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cmake-utils

DESCRIPTION="SocketCAN over Ethernet tunnel"
HOMEPAGE="https://github.com/mguentner/cannelloni"
SRC_URI="https://github.com/mguentner/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sctp"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
	-DCMAKE_BUILD_TYPE=Release
	-DSCTP_SUPPORT=$(usex sctp)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake_src_install
}
