# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1

DESCRIPTION="A link-local XMPP connection manager for Telepathy"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz
	https://src.fedoraproject.org/rpms/telepathy-salut/raw/master/f/${P}-python3.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ~ppc64 sparc x86 ~x86-linux"
IUSE="gnutls test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/dbus-glib-0.61
	dev-libs/libxml2
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.1.0
	>=net-libs/telepathy-glib-0.17.1
	>=net-dns/avahi-0.6.22[dbus]
	net-libs/libsoup:2.4
	sys-apps/util-linux
	dev-db/sqlite:3
	gnutls? ( >=net-libs/gnutls-2.10.2 )
	!gnutls? ( >=dev-libs/openssl-0.9.8g:0=[-bindist(-)] )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
	virtual/pkgconfig
	test? (
		>=dev-libs/check-0.9.4
		net-libs/libgsasl
	)
"
# FIXME: needs xmppstream python module
#               >=net-dns/avahi-0.6.22[python]

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-uninitialized.patch # upstream bug #37701
	"${FILESDIR}"/${P}-openssl-1.1.patch # bug #663994
	"${DISTDIR}"/${P}-python3.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	econf \
		--disable-coding-style-checks \
		--disable-plugins \
		--disable-Werror \
		--disable-static \
		--disable-avahi-tests \
		--with-tls=$(usex gnutls gnutls openssl)
		#$(use_enable test avahi-tests)

	# false positives according to bug #413581:
	# unrecognized options: --disable-plugins, --disable-avahi-tests
}

src_install() {
	MAKEOPTS+=" -j1" default # bug 413581
	find "${D}" -name '*.la' -delete || die
}
