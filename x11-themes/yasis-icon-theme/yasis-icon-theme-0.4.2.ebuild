# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xdg-utils

DESCRIPTION="A scalable icon theme called Yasis"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="http://www.silvestre.com.ar/icons/yasis-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( || ( x11-themes/adwaita-icon-theme x11-themes/nuovo-icon-theme ) )"
DEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	dodoc yasis/{AUTHORS,README}
	rm -f yasis/{AUTHORS,COPYING,DONATE,INSTALL,README}

	insinto /usr/share/icons
	doins -r yasis
}

pkg_postinst() {
	xdg_icon_cache_update
}
pkg_postrm() {
	xdg_icon_cache_update
}
