# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit versionator xdg-utils

MY_PV="$(delete_all_version_separators ${PV})"

DESCRIPTION="A scalable icon theme called Nou"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="http://www.silvestre.com.ar/icons/Nou-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( || ( x11-themes/tango-icon-theme x11-themes/adwaita-icon-theme ) )"
DEPEND=""

RESTRICT="binchecks strip"

S=${WORKDIR}

src_install() {
	dodoc Nou/{AUTHORS,README}
	rm -f Nou/{AUTHORS,COPYING,DONATE,INSTALL,README,.icon-theme.cache}

	insinto /usr/share/icons
	doins -r Nou
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
