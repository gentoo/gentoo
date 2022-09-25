# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson # gnome.org meson xdg

DESCRIPTION="Makes power profiles handling available over D-Bus."
HOMEPAGE="https://gitlab.freedesktop.org/hadess/power-profiles-daemon/"
SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gtk-doc pylint"

RDEPEND="
	>=dev-libs/glib-2.0:2
	>=dev-libs/libgudev-234
	sys-power/upower
	>=sys-auth/polkit-0.114
	pylint? ( dev-python/pylint )
	sys-apps/systemd
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gi-docgen )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use pylint)
		-Dtests=false
	)
	meson_src_configure
}
