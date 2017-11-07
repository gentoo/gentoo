# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_P="${PN}_${PV}"

DESCRIPTION="The Solidity Contract-Oriented Programming Language"
HOMEPAGE="https://github.com/ethereum/solidity"
SRC_URI="https://github.com/ethereum/${PN}/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-libs/jsoncpp-1.8.1:=
	>=dev-libs/boost-1.54:=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Upstream downloads and builds a static jsoncpp during build
	"${FILESDIR}"/${P}-fix-cmake-external-jsoncpp.diff
)

src_configure() {
	local mycmakeargs=(
		"-DBoost_USE_STATIC_LIBS=off"
	)

	cmake-utils_src_configure
}
