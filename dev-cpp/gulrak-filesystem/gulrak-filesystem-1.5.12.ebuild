# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only single-file std::filesystem compatible helper library"
HOMEPAGE="https://github.com/gulrak/filesystem"
SRC_URI="https://github.com/gulrak/filesystem/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${P#*-}"

src_configure() {
	local mycmakeargs=(
		-DGHC_FILESYSTEM_BUILD_EXAMPLES=OFF
		-DGHC_FILESYSTEM_BUILD_TESTING=$(usex test)
		-DGHC_FILESYSTEM_WITH_INSTALL=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	docinto examples
	use examples && dodoc examples/*.cpp
}
