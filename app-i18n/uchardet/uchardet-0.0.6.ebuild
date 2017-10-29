# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="An encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
SRC_URI="https://www.freedesktop.org/software/uchardet/releases/${P}.tar.xz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 x86"
IUSE="static-libs test"

src_prepare() {
	cmake-utils_src_prepare
	use test || cmake_comment_add_subdirectory test

	# Remove flaky test. See Gentoo bug 631852.
	# Track https://bugs.freedesktop.org/show_bug.cgi?id=101033
	rm test/th/tis-620.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}
