# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="A user interface designer for GTK+ and GNOME"
HOMEPAGE="https://glade.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="3.10/6" # subslot = suffix of libgladeui-2.so
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 sparc x86"

IUSE="debug +introspection python webkit"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/atk[introspection?]
	>=dev-libs/glib-2.53.2:2
	>=dev-libs/libxml2-2.4.0:2
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.20.0:3[introspection?]
	x11-libs/pango[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.32:= )
	python? (
		${PYTHON_DEPS}
		x11-libs/gtk+:3[introspection]
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.8:3[${PYTHON_MULTI_USEDEP}]
		')
	)
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	virtual/pkgconfig
"
# eautoreconf requires:
#	app-text/yelp-tools
#	dev-libs/gobject-introspection-common
#	gnome-base/gnome-common

RESTRICT="test" # https://gitlab.gnome.org/GNOME/glade/issues/333

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
		$(use_enable python) \
		$(use_enable webkit webkit2gtk)
}

src_test() {
	virtx emake check
}

src_install() {
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
