# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

inherit gnome.org gnome2-utils meson virtualx xdg python-single-r1

DESCRIPTION="Media player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Videos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="gtk-doc +python test"
# see bug #359379
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.19.4:3[introspection]
	>=media-libs/gstreamer-1.6.0:1.0
	>=media-libs/gst-plugins-base-1.6.0:1.0[pango]
	>=media-libs/gst-plugins-good-1.6.0:1.0
	>=media-libs/grilo-0.3.0:0.3[playlist]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=dev-libs/totem-pl-parser-3.26.5:0=[introspection]
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-2.99.2:3.0
	>=media-libs/clutter-gtk-1.8.1:1.0
	gnome-base/gnome-desktop:3=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2
	>=dev-libs/gobject-introspection-1.54:=

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/pygobject-2.90.3:3[${PYTHON_MULTI_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}
	media-plugins/grilo-plugins:0.3
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/adwaita-icon-theme
	python? (
		x11-libs/pango[introspection]
		>=dev-libs/libpeas-1.1.0[python,${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		')
	)
"
BDEPEND="
	dev-lang/perl
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.5 )
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"
# perl for pod2man
# Prevent dev-python/pylint dep, bug #482538

PATCHES=(
	"${FILESDIR}"/3.38.0-gst-inspect-sandbox.patch # Allow disabling calls to gst-inspect (sandbox issue)
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Drop pointless samplepython plugin from build
	sed -e '/samplepython/d' -i src/plugins/meson.build || die
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable-easy-codec-installation=yes
		-Denable-python=$(usex python yes no)
		-Dwith-plugins=all # in 3.34.1 only builtin and python plugins are left, and python is extra controlled by enable-python
		$(meson_use gtk-doc enable-gtk-doc)
		-Dgst-inspect=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use python ; then
		python_optimize "${ED}"/usr/$(get_libdir)/totem/plugins/
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

src_test() {
	virtx meson_src_test
}
