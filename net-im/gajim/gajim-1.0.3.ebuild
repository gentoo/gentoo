# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite,xml"
DISTUTILS_SINGLE_IMPL=1

inherit gnome2-utils distutils-r1 versionator xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://www.gajim.org/"
SRC_URI="https://www.gajim.org/downloads/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
KEYWORDS="amd64 x86"
IUSE="+crypt geolocation jingle keyring networkmanager remote rst +spell upnp
	+webp"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo]
	>=x11-libs/gtk+-3.22:3[introspection]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pygobject[cairo,${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.6.6[${PYTHON_USEDEP}]
	x11-libs/libXScrnSaver
	crypt? (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		>=dev-python/python-gnupg-0.4.0[${PYTHON_USEDEP}] )
	geolocation? ( app-misc/geoclue[introspection] )
	jingle? (
		net-libs/farstream:0.2[introspection]
		media-libs/gstreamer:1.0[introspection]
		media-libs/gst-plugins-base:1.0[introspection]
		media-libs/gst-plugins-ugly:1.0
	)
	keyring? (
		app-crypt/libsecret[crypt,introspection]
		dev-python/keyring[${PYTHON_USEDEP}]
	)
	networkmanager? ( net-misc/networkmanager[introspection] )
	remote? (
		>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
		sys-apps/dbus[X]
	)
	rst? ( dev-python/docutils[${PYTHON_USEDEP}] )
	spell? (
		app-text/gspell[introspection]
		app-text/hunspell
	)
	upnp? ( net-libs/gupnp-igd[introspection] )
	webp? ( dev-python/pillow[${PYTHON_USEDEP}] )"

RESTRICT="test"

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
