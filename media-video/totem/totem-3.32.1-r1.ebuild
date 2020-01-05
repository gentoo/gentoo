# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"

inherit gnome.org gnome2-utils meson virtualx xdg python-single-r1

DESCRIPTION="Media player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Videos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="cdr gtk-doc +introspection lirc +python test"
# see bug #359379
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"

# FIXME:
# Runtime dependency on gnome-session-2.91
DEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.19.4:3[introspection?]
	>=media-libs/gstreamer-1.6.0:1.0
	>=media-libs/gst-plugins-base-1.6.0:1.0[pango]
	>=media-libs/gst-plugins-good-1.6.0:1.0
	>=media-libs/grilo-0.3.0:0.3[playlist]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=dev-libs/totem-pl-parser-3.10.1:0=[introspection?]
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-2.99.2:3.0
	>=media-libs/clutter-gtk-1.8.1:1.0
	gnome-base/gnome-desktop:3=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )

	cdr? ( >=dev-libs/libxml2-2.6:2 )
	lirc? ( app-misc/lirc )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}
	media-plugins/grilo-plugins:0.3
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/adwaita-icon-theme
	python? (
		>=dev-libs/libpeas-1.1.0[python,${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}] )
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
	"${FILESDIR}"/${PV}-control-plugins.patch # Do not force all plugins
	"${FILESDIR}"/3.26-gst-inspect-sandbox.patch # Allow disabling calls to gst-inspect (sandbox issue)
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# Disabled: samplepython
	local plugins="apple-trailers,autoload-subtitles"
	plugins+=",im-status,media-player-keys,properties"
	plugins+=",recent,rotation,save-file,screensaver,screenshot"
	plugins+=",skipto,variable-rate,vimeo"
	use cdr && plugins+=",brasero-disc-recorder"
	use lirc && plugins+=",lirc"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"

	local emesonargs=(
		-Denable-easy-codec-installation=yes
		-Denable-python=$(usex python yes no)
		-Dwith-plugins=${plugins}
		$(meson_use gtk-doc enable-gtk-doc)
		-Denable-introspection=$(usex introspection yes no)
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
