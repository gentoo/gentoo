# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/stable/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="systemd X"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-cpp/glibmm-2.46:2
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.22:3[X(+)]
	>=dev-cpp/gtkmm-3.3.18:3.0
	>=dev-cpp/atkmm-2.28:0
	>=gnome-base/libgtop-2.37.2:2=
	>=gui-libs/libhandy-1.5.0:1=
	>=gnome-base/librsvg-2.35:2
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
