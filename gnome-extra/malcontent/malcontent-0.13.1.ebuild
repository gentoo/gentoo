# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson xdg

DESCRIPTION="Parental control support for applications"
HOMEPAGE="https://gitlab.freedesktop.org/pwithnall/malcontent"
SRC_URI="https://gitlab.freedesktop.org/pwithnall/malcontent/-/archive/${PV}/${PN}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-apps/dbus-1
	sys-auth/polkit
	>=dev-util/gi-docgen-2025.3
	>=gui-libs/gtk-4.12
	>=gui-libs/libadwaita-1.6.0
	sys-apps/accountsservice
	dev-libs/appstream
	sys-apps/dbus
	dev-libs/glib:2
	sys-libs/pam
	sys-apps/flatpak
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-Dpamlibdir="/lib64/security/"
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
