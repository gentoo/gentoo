# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils meson

MY_PN="desktop-icons-ng"
MY_P="${MY_PN}-${PV}"
COMMIT="14bebee3e2e4df561b9c930af6def98307fddef3"

DESCRIPTION="Desktop icon support for GNOME Shell"
HOMEPAGE="https://gitlab.com/rastersoft/desktop-icons-ng"
SRC_URI="https://gitlab.com/rastersoft/desktop-icons-ng/-/archive/${PV}/${P}.tar.bz2"
S="${WORKDIR}/${MY_P}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-46
	>=gnome-base/nautilus-3.38
"
DEPEND="${COMMON_DEPEND}"

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
}
