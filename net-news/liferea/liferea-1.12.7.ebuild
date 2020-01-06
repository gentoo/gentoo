# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit gnome2 python-single-r1

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo feeds"
HOMEPAGE="https://lzone.de/liferea/"
SRC_URI="https://github.com/lwindolf/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libpeas[gtk,python,${PYTHON_USEDEP}]
	dev-libs/libxml2:2
	dev-libs/libxslt
	gnome-base/gsettings-desktop-schemas
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_compile() {
	# Workaround crash in libwebkit2gtk-4.0.so
	# https://bugs.gentoo.org/704594
	WEBKIT_DISABLE_COMPOSITING_MODE=1 \
		gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "Additional features can be enabled via"
	elog "\tapp-crypt/libsecret[introspection] for Libsecret Support plugin"
	elog "\tdev-python/pycairo and x11-libs/gdk-pixbuf[introspection] for Tray Icon (GNOME Classic) plugin"
	elog "\tmedia-libs/gstreamer[introspection] for Media Player plugin"
	elog "\tnet-misc/networkmanager for monitoring network status"
	elog "\tx11-libs/libnotify[introspection] for Popup Notifications plugin"
}
