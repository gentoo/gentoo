# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
# Python is used during build for some scripted source files generation (and twisted tests)
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1

DESCRIPTION="A XMPP connection manager, handles single and multi user chats and voice calls"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
IUSE="gnutls +jingle plugins test"

# Prevent false positives due nested configure
QA_CONFIGURE_OPTIONS=".*"

# FIXME: missing sasl-2 for tests ? (automagic)
# missing libiphb for wocky ?
# x11-libs/gtksourceview:3.0 needed by telepathy-gabble-xmpp-console, bug #495184
# Keep in mind some deps or higher minimum versions are in ext/wocky/configure.ac
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=sys-apps/dbus-1.1.0
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.9

	dev-libs/libxml2
	dev-db/sqlite:3

	gnutls? ( >=net-libs/gnutls-2.10.2 )
	!gnutls? ( >=dev-libs/openssl-0.9.8g:0[-bindist] )
	jingle? (
		>=net-libs/libsoup-2.42
		>=net-libs/libnice-0.0.11 )
	plugins? ( x11-libs/gtksourceview:3.0[introspection] )

	!<net-im/telepathy-mission-control-5.5.0
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.17
	dev-libs/libxslt
	virtual/pkgconfig
"
# Twisted tests fail if bad ipv6 setup, upstream bug #30565
# Random twisted tests fail with org.freedesktop.DBus.Error.NoReply for some reason
# pygobject:2 is needed by twisted-17 for gtk2reactor usage by gabble
#test? (
#	dev-python/pygobject:2
#	|| (
#	>=dev-python/twisted-16.0.0
#	(	>=dev-python/twisted-core-0.8.2
#		>=dev-python/twisted-words-0.8.2
#		>=dev-python/dbus-python-0.83
#	) )
#)

PATCHES=(
	# Fix build with USE=-jingle, bug #523230
	"${FILESDIR}"/${P}-build-fix-no-jingle.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-coding-style-checks \
		--disable-static \
		--disable-Werror \
		--enable-file-transfer \
		$(use_enable jingle voip) \
		$(use_enable jingle google-relay) \
		$(use_enable plugins) \
		--with-tls=$(usex gnutls gnutls openssl)
}

src_test() {
	# This runs only C tests (see tests/README):
	emake -C tests check-TESTS
}
