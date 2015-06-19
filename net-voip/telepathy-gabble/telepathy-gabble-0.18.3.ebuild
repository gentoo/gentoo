# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/telepathy-gabble/telepathy-gabble-0.18.3.ebuild,v 1.4 2015/04/08 18:20:12 mgorny Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 eutils python-any-r1

DESCRIPTION="A Jabber/XMPP connection manager, with handling of single and multi user chats and voice calls"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="gnutls +jingle plugins test"

# Prevent false positives due nested configure
QA_CONFIGURE_OPTIONS=".*"

# FIXME: missing sasl-2 for tests ? (automagic)
# missing libiphb for wocky ?
# x11-libs/gtksourceview:3.0 needed by telepathy-gabble-xmpp-console, bug #495184
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=sys-apps/dbus-1.1.0
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.9

	dev-db/sqlite:3
	dev-libs/libxml2

	gnutls? ( >=net-libs/gnutls-2.10.2 )
	!gnutls? ( >=dev-libs/openssl-0.9.8g:0[-bindist] )
	jingle? ( || ( net-libs/libsoup:2.4[ssl]
		>=net-libs/libsoup-2.33.1 )
		>=net-libs/libnice-0.0.11 )
	plugins? ( x11-libs/gtksourceview:3.0[introspection] )

	!<net-im/telepathy-mission-control-5.5.0
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.17
	dev-libs/libxslt
	test? ( >=dev-python/twisted-core-0.8.2
		>=dev-python/twisted-words-0.8.2
		>=dev-python/dbus-python-0.83 )
"

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
	# Twisted tests fail, upstream bug #30565
	emake -C tests check-TESTS
}
