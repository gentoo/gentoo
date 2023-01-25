# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for making, reading and applying deltarpm packages"
HOMEPAGE="https://github.com/rpm-software-management/drpm"
if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rpm-software-management/drpm/"
else
	SRC_URI="https://github.com/rpm-software-management/drpm/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

IUSE="lzip test zstd"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:=
	app-arch/rpm
	app-arch/xz-utils
	dev-libs/openssl:=
	sys-libs/zlib
	lzip? ( app-arch/lzlib )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}
	test? ( dev-util/cmocka )
"

PATCHES=( "${FILESDIR}"/${P}-c99.patch )

src_configure() {
	local mycmakeargs=(
		-DHAVE_LZLIB_DEVEL=$(usex lzip ON OFF)
		-DWITH_ZSTD=$(usex zstd ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}
