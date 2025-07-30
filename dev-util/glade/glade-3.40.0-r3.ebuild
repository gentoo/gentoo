# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit flag-o-matic gnome2 python-single-r1 meson optfeature virtualx

DESCRIPTION="A user interface designer for GTK+ and GNOME"
HOMEPAGE="https://glade.gnome.org https://gitlab.gnome.org/GNOME/glade"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="3.10/13" # subslot = suffix of libgladeui-2.so
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

IUSE="X gjs gtk-doc +introspection python wayland webkit"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-libs/atk[introspection?]
	>=dev-libs/glib-2.53.2:2
	>=dev-libs/libxml2-2.4.0:2=
	x11-libs/cairo:=[X?]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.22.0:3[X?,introspection?,wayland?]
	x11-libs/pango[X?,introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	gjs? ( >=dev-libs/gjs-1.64.0 )
	python? (
		${PYTHON_DEPS}
		x11-libs/gtk+:3[introspection]
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
		')
	)
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4.1[X?,wayland?] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.2
	)
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
	# https://gitlab.gnome.org/GNOME/glade/-/issues/555
	"${FILESDIR}"/${PN}-3.40.0-webkitgtk-4.1.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

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
