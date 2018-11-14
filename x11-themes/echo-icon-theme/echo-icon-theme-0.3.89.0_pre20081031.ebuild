# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="SVG icon theme from the Echo Icon project"
HOMEPAGE="https://fedorahosted.org/echo-icon-theme"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=x11-misc/icon-naming-utils-0.8.90
"

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${PV/_pre*}"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
