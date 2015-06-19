# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qiv/qiv-2.2.4.ebuild,v 1.5 2012/05/28 23:54:50 blueness Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Quick Image Viewer"
HOMEPAGE="http://spiegl.de/qiv/"
SRC_URI="http://spiegl.de/qiv/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="xinerama"

RDEPEND=">=x11-libs/gtk+-2.12:2
	media-libs/imlib2[X]
	!<media-gfx/pqiv-0.11
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		Makefile || die

	if ! use xinerama; then
		sed -i \
			-e 's:-DGTD_XINERAMA::' \
			Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin qiv
	doman qiv.1
	dodoc Changelog qiv-command.example README README.TODO
}
