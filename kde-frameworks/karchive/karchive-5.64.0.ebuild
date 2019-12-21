# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ecm kde.org

DESCRIPTION="Framework for reading, creation, and manipulation of various archive formats"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="+bzip2 +lzma"

DEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package bzip2 BZip2)
		$(cmake_use_find_package lzma LibLZMA)
	)

	ecm_src_configure
}
