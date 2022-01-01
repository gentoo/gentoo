# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ecm kde.org

DESCRIPTION="Framework for reading, creation, and manipulation of various archive formats"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+zstd"

DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="zstd? ( virtual/pkgconfig )"

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use zstd; then
		sed -e "s/^pkg_check_modules.*LibZstd/#&/" -i CMakeLists.txt || die
	fi
}
