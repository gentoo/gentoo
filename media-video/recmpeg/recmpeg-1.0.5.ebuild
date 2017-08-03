# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple libfame-based video encoder, compresses raw video sequences to MPEG video"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"

IUSE="cpu_flags_x86_mmx cpu_flags_x86_sse"

RDEPEND=">=media-libs/libfame-0.9.0"
DEPEND="${DEPEND}"

DOCS=( CHANGES README )

src_configure() {
	econf \
		$(use cpu_flags_x86_mmx && echo "--enable-mmx") \
		$(use cpu_flags_x86_sse && echo "--enable-sse")
}
