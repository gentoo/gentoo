# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils xdg

DESCRIPTION="A simple MTP client for MP3 players"
HOMEPAGE="http://gmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/flac:=
	media-libs/libid3tag:=
	media-libs/libmtp:=
	media-libs/libvorbis
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.3.11-fno-common.patch )

src_configure() {
	econf --with-gtk3
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
