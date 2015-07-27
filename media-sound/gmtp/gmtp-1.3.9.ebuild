# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmtp/gmtp-1.3.9.ebuild,v 1.1 2015/07/27 20:55:08 polynomial-c Exp $

EAPI=5
inherit gnome2-utils

DESCRIPTION="A simple MTP client for MP3 players"
HOMEPAGE="http://gmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

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

src_configure() {
	econf --with-gtk3
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
