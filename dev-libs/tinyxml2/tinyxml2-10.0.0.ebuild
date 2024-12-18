# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No meson because of bug #791163
inherit cmake

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/10"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
