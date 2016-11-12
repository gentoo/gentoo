# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils savedconfig toolchain-funcs

DESCRIPTION="Simple (or small or suckless) X Image Viewer"
HOMEPAGE="https://github.com/muennich/sxiv/"
SRC_URI="https://github.com/muennich/sxiv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-libs/libexif
	media-libs/giflib
	media-libs/imlib2[X]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i '/^LDFLAGS/d' Makefile || die
	tc-export CC

	restore_config config.h
	default
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
	emake -C icon DESTDIR="${ED}" PREFIX=/usr install
	dodoc README.md
	domenu sxiv.desktop

	save_config config.h
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
