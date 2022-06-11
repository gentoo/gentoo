# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fork of the popular zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/zlib-ng/minizip-ng"
SRC_URI="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/3.0.6.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+compat test"

DEPEND="app-arch/bzip2
	app-arch/zstd
	app-arch/xz-utils
	dev-libs/openssl:=
	|| ( sys-libs/zlib sys-libs/zlib-ng )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/minizip-ng # do not mix up with libzip
		-DMZ_BUILD_TESTS=$(usex test)
		-DMZ_COMPAT=$(usex compat)
		-DMZ_PROJECT_SUFFIX=-ng # Force -ng suffix even with compat
	)
	cmake_src_configure
}
