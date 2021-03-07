# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only C++11 serialization library"
HOMEPAGE="https://uscilab.github.io/cereal/"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/boost )"

src_configure() {
	local mycmakeargs=(
		-DJUST_INSTALL_CEREAL=$(usex !test)
		-DWITH_WERROR=OFF
	)
	cmake_src_configure
}
