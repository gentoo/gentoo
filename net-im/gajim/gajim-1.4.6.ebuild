# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
PYTHON_REQ_USE="sqlite,xml(+)"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://gajim.org/"
SRC_URI="https://gajim.org/downloads/$(ver_cut 1-2)/${P/_p/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="+crypt geolocation jingle omemo remote rst +spell upnp +webp"
S="${WORKDIR}/${P%_p2}"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo(+)]
	>=x11-libs/gtk+-3.22:3[introspection]
	x11-libs/gtksourceview:4"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/precis-i18n[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/python-nbxmpp-3.0.0[${PYTHON_USEDEP}]
		<dev-python/python-nbxmpp-4.0.0[${PYTHON_USEDEP}]
		x11-libs/libXScrnSaver
		app-crypt/libsecret[crypt,introspection]
		dev-python/keyring[${PYTHON_USEDEP}]
		>=dev-python/secretstorage-3.1.1[${PYTHON_USEDEP}]
		dev-python/css-parser[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		net-libs/libsoup[introspection]
		media-libs/gsound[introspection]
		dev-python/pillow[${PYTHON_USEDEP}]
		crypt? (
			dev-python/pycryptodome[${PYTHON_USEDEP}]
			>=dev-python/python-gnupg-0.4.0[${PYTHON_USEDEP}] )
		geolocation? ( app-misc/geoclue[introspection] )
		jingle? (
			net-libs/farstream:0.2[introspection]
			media-libs/gstreamer:1.0[introspection]
			media-libs/gst-plugins-base:1.0[introspection]
			media-libs/gst-plugins-ugly:1.0
			media-plugins/gst-plugins-gtk
		)
		omemo? (
			dev-python/python-axolotl[${PYTHON_USEDEP}]
			dev-python/qrcode[${PYTHON_USEDEP}]
			dev-python/cryptography[${PYTHON_USEDEP}]
		)
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
	')"

src_install() {
	distutils-r1_src_install

	# avoid precompressed man pages
	rm -r "${D}/usr/share/man"
	doman data/*.1
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

# Tests are unfortunately regularly broken
RESTRICT="test"
