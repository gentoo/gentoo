# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils meson

MY_PN="${PN/gnome-shell-extension-/}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A GNOME Shell extension for providing desktop icons"
HOMEPAGE="https://gitlab.gnome.org/World/ShellExtensions/desktop-icons"
SRC_URI="https://gitlab.gnome.org/World/ShellExtensions/${MY_PN}/uploads/5de9fa81ff4ef1d16edcd96041063f91/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.30.0
	>=gnome-base/nautilus-3.30.4
	sys-apps/xdg-desktop-portal
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

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
