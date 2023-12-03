# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="https://libvirt.org/ https://gitlab.com/libvirt/libvirt-glib/"
SRC_URI="https://libvirt.org/sources/glib/${P}.tar.xz"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="gtk-doc +introspection test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/libxml2-2.9.1
	>=app-emulation/libvirt-1.2.8:=
	>=dev-libs/glib-2.48.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.48.0:= )
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0-Make-xmlError-structs-constant.patch
	"${FILESDIR}"/${PN}-4.0.0-libvirt-gconfig-Add-more-libxml-includes.patch
)

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
