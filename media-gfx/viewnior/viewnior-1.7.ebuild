# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit xdg-utils gnome2-utils meson

MY_PN=Viewnior
DESCRIPTION="Fast and simple image viewer"
HOMEPAGE="https://siyanpanayotov.com/project/viewnior/ https://github.com/hellosiyan/Viewnior"
SRC_URI="https://github.com/hellosiyan/${MY_PN}/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib:2
	media-gfx/exiv2:0=
	>=x11-libs/gtk+-2.20:2
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}
	dev-util/glib-utils
"

S="${WORKDIR}/${MY_PN}-${P}"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
