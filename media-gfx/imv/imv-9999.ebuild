# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils fdo-mime git-r3

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
HOMEPAGE="https://github.com/eXeC64/imv"
EGIT_REPO_URI="https://github.com/eXeC64/imv.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/fontconfig
	media-libs/libsdl2
	media-libs/sdl2-ttf
	media-libs/freeimage
"

DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
