# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmtp/gmtp-1.3.3.ebuild,v 1.2 2012/06/22 05:49:44 ssuominen Exp $

EAPI=4
inherit gnome2-utils toolchain-funcs

DESCRIPTION="A simple MTP client for MP3 players"
HOMEPAGE="http://gmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-i386.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	media-libs/flac
	media-libs/libid3tag
	media-libs/libmtp
	media-libs/libvorbis
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/gMTP

src_prepare() {
	sed -i \
		-e '/CFLAGS/s:-g::' \
		-e '/glib-compile-schemas/d' \
		Makefile || die
}

src_compile() {
	emake gtk3 CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install-gtk3 register-gsettings-schemas
	dodoc AUTHORS ChangeLog README
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
