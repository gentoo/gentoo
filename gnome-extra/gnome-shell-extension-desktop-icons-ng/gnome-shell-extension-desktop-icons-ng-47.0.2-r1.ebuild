# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils meson

MY_PN="desktop-icons-ng"
MY_P="${MY_PN}-${PV}"
COMMIT="9c2f2bc688e9c95335c64f1b3a6ad0cc2051d7b4"

DESCRIPTION="Fork from the desktop-icons project, with several enhancements like Drag'n'Drop"
HOMEPAGE="https://gitlab.com/rastersoft/desktop-icons-ng"
SRC_URI="https://gitlab.com/rastersoft/desktop-icons-ng/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.38
	>=gnome-base/nautilus-3.38
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}-${COMMIT}"

PATCHES=(
	"${FILESDIR}/${P}-gnome44.patch"
)

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
