# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="header-only C++11 serialization library"
HOMEPAGE="http://uscilab.github.io/cereal/"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-libs/boost )"

src_prepare() {
	sed -i 's/-Werror//' CMakeLists.txt || die
	default
}

src_configure() {
	mycmakeargs=(
		-DJUST_INSTALL_CEREAL=$(usex !test)
	)
	cmake-utils_src_configure
}
