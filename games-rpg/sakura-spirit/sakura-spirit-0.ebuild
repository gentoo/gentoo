# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg-utils

RENPY_SLOT="6.99"
MY_PN="Sakura Spirit"

DESCRIPTION="Adult-themed visual novel and dating simulator set in Japan"
HOMEPAGE="http://wingedcloud.com"
SRC_URI="${MY_PN/ /_}-linux.tar"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist fetch"

RDEPEND="games-engines/renpy:${RENPY_SLOT}"

S="${WORKDIR}/${MY_PN/ /_}-linux"

pkg_nofetch() {
	einfo "If you have ${SRC_URI} as distributed by Humble Bundle then move"
	einfo "it to your distfiles directory. If you have some other version then"
	einfo "please contact the Gentoo Games team."
}

src_install() {
	insinto /usr/share/${PN}
	doins -r game/*

	make_wrapper ${PN} "renpy-${RENPY_SLOT} '${EPREFIX}/usr/share/${PN}'"
	make_desktop_entry ${PN} "${MY_PN}" applications-games

	docinto html
	dodoc README.html
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
