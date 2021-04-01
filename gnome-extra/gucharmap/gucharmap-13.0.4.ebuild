# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit gnome2-utils meson vala xdg

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="2.90"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 sparc x86"

UNICODE_VERSION="13.0"

IUSE="debug +introspection gtk-doc vala"
REQUIRED_USE="vala? ( introspection )"

BDEPEND="virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
	gtk-doc? ( >=dev-util/gtk-doc-1 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	${vala_depend}"

DEPEND="=app-i18n/unicode-data-${UNICODE_VERSION}*
	>=dev-libs/glib-2.32:2
	media-libs/freetype:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=x11-libs/pango-1.42.4-r2[introspection?]"

RDEPEND="${DEPEND}"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ducd_path="${EPREFIX}/usr/share/unicode-data"
		$(meson_use debug dbg)
		$(meson_use gtk-doc docs)
		$(meson_use introspection gir)
		$(meson_use vala vapi)
	)

	meson_src_configure
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
