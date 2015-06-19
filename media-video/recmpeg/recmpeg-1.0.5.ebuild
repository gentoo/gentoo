# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/recmpeg/recmpeg-1.0.5.ebuild,v 1.12 2015/01/29 19:16:42 mgorny Exp $

DESCRIPTION="Simple libfame-based video encoder which compresses raw video sequences to MPEG video"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="cpu_flags_x86_mmx cpu_flags_x86_sse"

DEPEND=">=media-libs/libfame-0.9.0"

src_compile() {
	local myconf

	use cpu_flags_x86_mmx && myconf="${myconf} --enable-mmx"
	use cpu_flags_x86_sse && myconf="${myconf} --enable-sse"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall install || die "einstall died"
	dodoc CHANGES README NEWS
}
