# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
if [ "${PV}" = 9999 ]
then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/uchardet/uchardet.git"
else
	SRC_URI="https://www.freedesktop.org/software/uchardet/releases/${P}.tar.xz"
fi

DESCRIPTION="An encoding detector library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/uchardet/"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cpu_flags_x86_sse2 static-libs test"
RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory test
}

src_configure() {
	local mycmakeargs=(
		-DTARGET_ARCHITECTURE="${ARCH}"
		-DBUILD_STATIC=$(usex static-libs)
		-DCHECK_SSE2=$(usex cpu_flags_x86_sse2)
	)
	cmake_src_configure
}
