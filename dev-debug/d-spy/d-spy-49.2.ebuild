# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="D-Spy is a simple tool to explore D-Bus connections"
HOMEPAGE="https://apps.gnome.org/Dspy/"

LICENSE="GPL-3+ LGPL-3+"
SLOT="1"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	>=dev-libs/glib-2.82:2
	>=gui-libs/gtk-4.16:4
	>=dev-libs/libdex-0.11
	>=gui-libs/libadwaita-1.7:1
"
RDEPEND="
	${DEPEND}
	>=sys-apps/dbus-1
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dbuilder=false
	)
	meson_src_configure
}
