# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap https://gitlab.gnome.org/GNOME/gucharmap/"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="2.90"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc ~x86"

UNICODE_VERSION="15.0"

IUSE="+introspection gtk-doc vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="media-libs/freetype:2
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=dev-libs/libpcre2-10.21:=
	=app-i18n/unicode-data-${UNICODE_VERSION}*
	>=x11-libs/pango-1.42.4-r2[introspection?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( >=dev-util/gtk-doc-1 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/14.0.1-install-user-help.patch
	"${FILESDIR}"/15.0.1-fix-file-conflicts.patch
)

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dcharmap=true
		-Ddbg=false # in 14.0.1 all this does is pass -ggdb3
		$(meson_use gtk-doc docs)
		$(meson_use introspection gir)
		-Dgtk3=true
		-Ducd_path="${EPREFIX}/usr/share/unicode-data"
		$(meson_use vala vapi)
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
