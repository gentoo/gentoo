# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala xdg

DESCRIPTION="Library and tool for working with Microsoft Cabinet (CAB) files"
HOMEPAGE="https://wiki.gnome.org/msitools"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86"

IUSE="gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.44:2
	sys-libs/zlib
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PV}-optional-vapi.patch ) # https://gitlab.gnome.org/GNOME/gcab/merge_requests/1

src_prepare() {
	xdg_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use test tests)
	)
	meson_src_configure
}
