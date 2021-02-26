# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Free implementation of the DVB Common Scrambling Algorithm - DVB/CSA"
HOMEPAGE="https://www.videolan.org/developers/libdvbcsa.html"
SRC_URI="https://download.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="amd64 ~arm ~arm64 x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug cpu_flags_x86_mmx cpu_flags_x86_sse2 static-libs"

src_configure() {
	econf \
		$(use_enable ppc altivec) \
		$(use_enable debug) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static) \
		$(use_enable x86 uint32) \
		$(use_enable amd64 uint64) \
		--enable-shared
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
