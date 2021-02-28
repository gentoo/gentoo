# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite,xml"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://gajim.org/"
SRC_URI="https://gajim.org/downloads/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+crypt geolocation jingle remote rst +spell upnp +webp"
S="${WORKDIR}/${PN}-${P}"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo(+)]
	>=x11-libs/gtk+-3.22:3[introspection]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip
	>=dev-util/intltool-0.40.1
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
		>=dev-python/python-nbxmpp-2.0.2[${PYTHON_USEDEP}]
		x11-libs/libXScrnSaver
		app-crypt/libsecret[crypt,introspection]
		dev-python/keyring[${PYTHON_USEDEP}]
		>=dev-python/secretstorage-3.1.1[${PYTHON_USEDEP}]
		dev-python/css-parser[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		net-libs/libsoup[introspection]
		media-libs/gsound[introspection]
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
		webp? ( dev-python/pillow[${PYTHON_USEDEP}] )
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
