# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for reading, creation, and manipulation of various archive formats"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+zstd"

DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
	zstd? ( virtual/pkgconfig )
"

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use zstd; then
		sed -e "s/^pkg_check_modules.*LibZstd/#&/" -i CMakeLists.txt || die
	fi
}
