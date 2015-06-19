# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subtitler-yuv/subtitler-yuv-0.6.5.ebuild,v 1.5 2012/09/06 13:03:41 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="for mjpegtools for adding subtitles, pictures, and effects embedded in the picture"
HOMEPAGE="http://panteltje.com/panteltje/subtitles/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e '/^CFLAGS/s:= -O2:+=:' \
		-e '/CFLAGS/s:gcc:$(CC):' \
		-e 's:gcc -o:$(CC) $(LDFLAGS) -o:' \
		-e 's:-L/usr/X11R6/lib/::' \
		-e 's:-lXpm:-lX11:' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin ${PN}
	dodoc CHANGES HOWTO_USE_THIS README*
	insinto /usr/share/${PN}
	doins *.{ppm,ppml,zip}
}
