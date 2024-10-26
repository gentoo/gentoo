# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://apps.gnome.org/SystemMonitor/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="systemd X"

RDEPEND="
	>=dev-cpp/glibmm-2.68:2.68
	>=dev-libs/glib-2.56.0:2
	>=gui-libs/gtk-4.12.0:4[X(+)?]
	>=dev-cpp/gtkmm-4.0.0:4.0
	>=gnome-base/libgtop-2.41.2:2=
	>=gui-libs/libadwaita-1.4.0:1
	>=gnome-base/librsvg-2.46:2
	>=dev-libs/libxml2-2.0:2
	X? ( >=x11-libs/libwnck-2.91.0:3 )
	systemd? ( >=sys-apps/systemd-44:0= )
"
# eautoreconf requires gnome-base/gnome-common
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	>=sys-auth/polkit-0.114
" # polkit needed at buildtime for ITS rules of policy files, first available in 0.114

src_configure() {
	local emesonargs=(
		$(meson_use X wnck)
		$(meson_use systemd)
		-Ddevelopment=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
