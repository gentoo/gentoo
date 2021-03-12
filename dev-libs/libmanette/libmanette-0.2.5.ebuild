# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Simple GObject game controller library"
HOMEPAGE="https://gitlab.gnome.org/aplazas/libmanette"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+introspection +udev +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.50:2
	udev? ( dev-libs/libgudev[introspection?] )
	dev-libs/libevdev
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
"
DEPEND="${DEPEND}
	vala? ( $(vala_depend) )
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature udev gudev)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}
