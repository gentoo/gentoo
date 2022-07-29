# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="HTTP web service mocking library"
HOMEPAGE="https://gitlab.freedesktop.org/pwithnall/uhttpmock"
SRC_URI="https://gitlab.freedesktop.org/pwithnall/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=net-libs/libsoup-2.47.3:2.4
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
"
BDEPEND="
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_feature vala vapi)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
