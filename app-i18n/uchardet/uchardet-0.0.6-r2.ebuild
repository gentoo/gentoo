# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="An encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
SRC_URI="https://www.freedesktop.org/software/uchardet/releases/${P}.tar.xz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ppc64 x86"
IUSE="cpu_flags_x86_sse2 static-libs test"

PATCHES=( "${FILESDIR}/${P}-enforce-IEEE-float-precision-r1.patch" )

src_prepare() {
	cmake-utils_src_prepare
	use test || cmake_comment_add_subdirectory test
}

src_configure() {
	local mycmakeargs=(
		-DTARGET_ARCHITECTURE="${ARCH}"
		-DBUILD_STATIC=$(usex static-libs)
		-DCHECK_SSE2=$(usex cpu_flags_x86_sse2)
	)
	cmake-utils_src_configure
}
