# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="https://libvirt.org/ https://gitlab.com/libvirt/libvirt-glib/"
SRC_URI="https://libvirt.org/sources/glib/${P}.tar.xz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="gtk-doc +introspection test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

BDEPEND="
	dev-util/glib-utils
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"
RDEPEND="
	>=dev-libs/libxml2-2.9.1
	>=app-emulation/libvirt-1.2.8:=
	>=dev-libs/glib-2.48.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.48.0:= )
"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc docs)
		$(meson_feature introspection)
		$(meson_feature test tests)
		$(meson_feature vala vapi)
	)

	meson_src_configure
}
