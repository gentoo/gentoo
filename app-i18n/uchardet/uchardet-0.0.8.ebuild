# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
SRC_URI="https://www.freedesktop.org/software/uchardet/releases/${P}.tar.xz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="cpu_flags_x86_sse2"

PATCHES=(
	"${FILESDIR}"/${P}-cmake4.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC=no
		-DCHECK_SSE2=$(usex cpu_flags_x86_sse2)
		-DTARGET_ARCHITECTURE="${ARCH}"
	)

	cmake_src_configure
}
