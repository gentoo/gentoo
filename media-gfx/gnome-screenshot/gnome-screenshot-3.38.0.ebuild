# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson readme.gentoo-r1 xdg

DESCRIPTION="Screenshot utility for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-screenshot"

LICENSE="GPL-2+"
SLOT="0"
IUSE="X"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

# libcanberra 0.26-r2 is needed for gtk+:3 fixes
DEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	>=dev-libs/glib-2.35.1:2[dbus]
	>=x11-libs/gtk+-3.12.0:3
	>=media-libs/libcanberra-0.26-r2[gtk3]
	>=gui-libs/libhandy-1:1=
"
RDEPEND="${DEPEND}
	>=gnome-base/gsettings-desktop-schemas-0.1.0
"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"

DOC_CONTENTS="${P} saves screenshots in ~/Pictures/ and defaults to
	non-interactive mode when launched from a terminal. If you want to choose
	where to save the screenshot, run 'gnome-screenshot --interactive'"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
