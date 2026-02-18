# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite,xml(+)"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature xdg

DESCRIPTION="GTK XMPP Client"
HOMEPAGE="https://gajim.org/"
SRC_URI="https://gajim.org/downloads/$(ver_cut 1-2)/${P/_p/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="voice"

# Same order as in upstream pyproject.toml please for the python dependencies

# For introspection dependencies consult upstream documentation and any gi.require_version in the code

# USE="voice" handles all video and audio.
# https://dev.gajim.org/gajim/gajim#rich-previews-images-and-voice-messages

# xdg-desktop-portal: apparent runtime requirement
# https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=a2963fc1a23747bbb60a3785bf06dd566e6d8be9

# httpx[http2,socks]: h2, socksio
# gst-plugins-rs (uses gtk4paintablesink): media-plugins/gst-plugin-gtk4
RDEPEND="
	>=dev-python/cryptography-3.4.8[${PYTHON_USEDEP}]
	dev-python/css-parser[${PYTHON_USEDEP}]
	>=dev-python/emoji-2.6.0[${PYTHON_USEDEP}]
	dev-python/h2[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	<dev-python/nbxmpp-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/nbxmpp-7.0.0[${PYTHON_USEDEP}]
	<dev-python/omemo-dr-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/omemo-dr-1.2.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.1.0[${PYTHON_USEDEP}]
	>=dev-python/precis-i18n-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.53.0:3[cairo,${PYTHON_USEDEP}]
	>=dev-python/qrcode-7.3.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0.0[${PYTHON_USEDEP}]
	dev-python/socksio[${PYTHON_USEDEP}]
	dev-python/truststore[${PYTHON_USEDEP}]

	>=dev-libs/glib-2.80[introspection(+)]
	>=gui-libs/gtk-4.17.5:4[introspection]
	gui-libs/gtksourceview:5[introspection]
	>=gui-libs/libadwaita-1.7.0[introspection]
	media-libs/graphene[introspection]
	net-libs/libsoup:3.0[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/pango-1.50.0[introspection]

	voice? (
		media-libs/gstreamer:1.0[introspection]
		media-libs/gst-plugins-bad
		media-libs/gst-plugins-base
		media-libs/gst-plugins-good
		media-libs/gst-plugins-ugly
		media-plugins/gst-plugins-gtk
		media-plugins/gst-plugins-libav
		media-plugins/gst-plugin-gtk4
		net-libs/farstream:0.2[introspection]
	)

	sys-apps/xdg-desktop-portal
"
BDEPEND="
	>=sys-devel/gettext-0.17-r1
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile_all() {
	# Generates manpages, app icons, translation and metadata
	./make.py build --dist unix || die
}

python_install_all() {
	# Installs manpages, app icons, translation and metadata
	./make.py install --dist unix --prefix="${ED}/usr" || die

	# Undo compression in ./make.py install
	gzip -d "${ED}"/usr/share/man/man1/*.gz || die

	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn "The chat database format changes when upgrading from 1.8.x to 1.9.x."
	ewarn "The first time the user starts Gajim, an automatic migration is performed."

	# https://dev.gajim.org/gajim/gajim/-/tree/master?ref_type=heads#optional-runtime-requirements
	#optfeature "Sentry error reporting to dev.gajim.org" dev-python/sentry-sdk
	optfeature "keyring support" app-crypt/libsecret[introspection]
	optfeature "spellchecking support" "app-text/hunspell app-text/libspelling:1"
	# https://dev.gajim.org/gajim/gajim/-/issues/11578
	#optfeature "better NAT traversing" net-libs/gupnp:1.6[introspection]
	optfeature "network lose detection" net-misc/networkmanager[introspection]
	optfeature "sharing your location" app-misc/geoclue:2.0[introspection]
	optfeature "notifcation sound support" media-libs/gsound[introspection]

	xdg_pkg_postinst
}
