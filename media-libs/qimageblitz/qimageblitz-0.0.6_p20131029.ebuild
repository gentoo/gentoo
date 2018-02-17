# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Graphical effect and filter library by KDE"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/qimageblitz/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
SLOT="0"
IUSE="altivec cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 debug"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gcc.patch" )

src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=OFF
		-DHAVE_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DHAVE_MMX=$(usex cpu_flags_x86_mmx)
		-DHAVE_SSE=$(usex cpu_flags_x86_sse)
		-DHAVE_SSE2=$(usex cpu_flags_x86_sse2)
	)
	use ppc && mycmakeargs+=( -DHAVE_ALTIVEC=$(usex altivec) )

	cmake-utils_src_configure
}
