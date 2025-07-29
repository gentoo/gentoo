# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for reading, creation, and manipulation of various archive formats"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="crypt +zstd"

DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib
	crypt? ( dev-libs/openssl:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	zstd? ( virtual/pkgconfig )
"

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use zstd; then
		sed -e "s/^pkg_check_modules.*LibZstd/#&/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_OPENSSL=$(usex crypt)
		-DWITH_LIBZSTD=$(usex zstd)
	)
	ecm_src_configure
}
