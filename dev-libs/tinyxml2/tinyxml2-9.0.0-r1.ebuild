# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/ https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/9"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
