# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome2 python-single-r1 meson optfeature virtualx

DESCRIPTION="A user interface designer for GTK+ and GNOME"
HOMEPAGE="https://glade.gnome.org https://gitlab.gnome.org/GNOME/glade"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="3.10/13" # subslot = suffix of libgladeui-2.so
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

IUSE="gjs gtk-doc +introspection python webkit"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-libs/atk[introspection?]
	>=dev-libs/glib-2.53.2:2
	>=dev-libs/libxml2-2.4.0:2
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	x11-libs/pango[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	gjs? ( >=dev-libs/gjs-1.64.0 )
	python? (
		${PYTHON_DEPS}
		x11-libs/gtk+:3[introspection]
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
		')
	)
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

RESTRICT="test" # https://gitlab.gnome.org/GNOME/glade/issues/333

PATCHES=(
	# To avoid file collison with other slots, rename help module.
	# Prevent the UI from loading glade:3's gladeui devhelp documentation.
	"${FILESDIR}"/${PN}-3.14.1-doc-version.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dgladeui=true
		$(meson_feature gjs)
		$(meson_feature python)
		$(meson_feature webkit webkit2gtk)

		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	gnome2_pkg_postinst

	optfeature_header
	optfeature "integration API documentation support" dev-util/devhelp
}
