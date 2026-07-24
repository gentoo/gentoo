# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HASH_UCHARDET=06029ec3340cdf6bf9a6a537dafb3f39eda0560e #979611

DESCRIPTION="Encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"
SRC_URI="
	https://gitlab.freedesktop.org/uchardet/uchardet/-/archive/${HASH_UCHARDET}/${PN}-${HASH_UCHARDET}.tar.bz2
"
S=${WORKDIR}/${PN}-${HASH_UCHARDET}

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="cpu_flags_x86_sse2"

CMAKE_SKIP_TESTS=(
	# https://gitlab.freedesktop.org/uchardet/uchardet/-/work_items/39
	# https://gitlab.freedesktop.org/uchardet/uchardet/-/merge_requests/15
	zh:gb18030
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC=no
		-DCHECK_SSE2=$(usex cpu_flags_x86_sse2)
		-DTARGET_ARCHITECTURE="${ARCH}"
	)

	cmake_src_configure
}
