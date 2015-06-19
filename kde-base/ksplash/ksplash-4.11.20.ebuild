# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksplash/ksplash-4.11.20.ebuild,v 1.1 2015/06/03 23:04:53 mrueg Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE splashscreen framework (the splashscreen of KDE itself, not of individual apps)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_3dnow altivec debug cpu_flags_x86_mmx cpu_flags_x86_sse
cpu_flags_x86_sse2 xinerama"

COMMONDEPEND="
	media-libs/libpng:0=
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXext
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMONDEPEND}
	xinerama? ( x11-proto/xineramaproto )
"
RDEPEND="${COMMONDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_has cpu_flags_x86_3dnow X86_3DNOW)
		$(cmake-utils_use_has altivec PPC_ALTIVEC)
		$(cmake-utils_use_has cpu_flags_x86_mmx X86_MMX)
		$(cmake-utils_use_has cpu_flags_x86_sse X86_SSE)
		$(cmake-utils_use_has cpu_flags_x86_sse2 X86_SSE2)
		$(cmake-utils_use_with xinerama)
	)

	kde4-meta_src_configure
}
