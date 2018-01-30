# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1 versionator virtualx

DESCRIPTION="A user interface designer for GTK+ and GNOME"
HOMEPAGE="https://glade.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="3.10/6" # subslot = suffix of libgladeui-2.so
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"

IUSE="debug +introspection python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/atk[introspection?]
	>=dev-libs/glib-2.32:2
	>=dev-libs/libxml2-2.4.0:2
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.20.0:3[introspection?]
	x11-libs/pango[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf requires:
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common

PATCHES=(
	# To avoid file collison with other slots, rename help module.
	# Prevent the UI from loading glade:3's gladeui devhelp documentation.
	"${FILESDIR}"/${PN}-3.14.1-doc-version.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-gladeui \
		--enable-libtool-lock \
		$(usex debug --enable-debug ' ') \
		$(use_enable introspection) \
		$(use_enable python)
}

src_test() {
	virtx emake check
}

src_install() {
	# modify Name in .desktop file to avoid confusion with other slots
	sed -e 's:^\(Name.*=Glade\):\1 '$(get_version_component_range 1-2): \
		-i data/glade.desktop || die "sed of data/glade.desktop failed"
	# modify name in .devhelp2 file to avoid shadowing with glade:3 docs
	sed -e 's:name="gladeui":name="gladeui-2":' \
		-i doc/html/gladeui.devhelp2 || die "sed of gladeui.devhelp2 failed"
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! has_version dev-util/devhelp ; then
		elog "You may want to install dev-util/devhelp for integration API"
		elog "documentation support."
	fi
}
