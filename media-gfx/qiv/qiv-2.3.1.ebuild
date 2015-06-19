# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qiv/qiv-2.3.1.ebuild,v 1.1 2013/12/29 03:57:02 radhermit Exp $

EAPI=5
inherit toolchain-funcs eutils fdo-mime gnome2-utils

DESCRIPTION="Quick Image Viewer"
HOMEPAGE="http://spiegl.de/qiv/"
SRC_URI="http://spiegl.de/qiv/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="exif lcms magic"

RDEPEND=">=x11-libs/gtk+-2.12:2
	media-libs/imlib2[X]
	exif? ( media-libs/libexif )
	lcms? ( media-libs/lcms:2 )
	magic? ( sys-apps/file )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		Makefile || die

	if ! use exif ; then
		sed -i 's/^EXIF =/#\0/' Makefile || die
	fi

	if ! use lcms ; then
		sed -i 's/^LCMS =/#\0/' Makefile || die
	fi

	if ! use magic ; then
		sed -i 's/^MAGIC =/#\0/' Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin qiv
	doman qiv.1
	dodoc Changelog contrib/qiv-command.example README README.TODO

	domenu qiv.desktop
	doicon qiv.png
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
