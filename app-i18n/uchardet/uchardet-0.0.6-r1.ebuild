# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils flag-o-matic

DESCRIPTION="An encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
SRC_URI="https://www.freedesktop.org/software/uchardet/releases/${P}.tar.xz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 x86"
IUSE="cpu_flags_x86_sse2 static-libs test"

src_prepare() {
	if use x86 ; then
		if use cpu_flags_x86_sse2 ; then
			# We support SSE2 so enforce SSE2 usage which isn't the default on x86
			append-flags -msse2 -mfpmath=sse
		else
			# We don't support SSE2 so enforce alternative
			# https://bugs.freedesktop.org/show_bug.cgi?id=101033
			append-flags -ffloat-store
		fi
	fi

	cmake-utils_src_prepare
	use test || cmake_comment_add_subdirectory test
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}
