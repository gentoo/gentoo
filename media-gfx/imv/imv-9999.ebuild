# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils git-r3

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
HOMEPAGE="https://github.com/eXeC64/imv"
EGIT_REPO_URI="https://github.com/eXeC64/imv.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	!sys-apps/renameutils
	media-libs/fontconfig
	media-libs/libsdl2
	media-libs/sdl2-ttf
	media-libs/freeimage
"

DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
