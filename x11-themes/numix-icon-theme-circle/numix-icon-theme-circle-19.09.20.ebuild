# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="An icon theme for Linux from the Numix project"
HOMEPAGE="https://github.com/numixproject"
SRC_URI="https://github.com/numixproject/numix-icon-theme-circle/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="x11-themes/numix-icon-theme"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/icons
	doins -r Numix-Circle{,-Light}

}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
