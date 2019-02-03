# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="A link-local XMPP connection manager for Telepathy"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ~ppc64 sparc x86 ~x86-linux"
IUSE="gnutls test"

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
	!gnutls? ( >=dev-libs/openssl-0.9.8g:0[-bindist] )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
	virtual/pkgconfig
	test? (
		>=dev-libs/check-0.9.4
		net-libs/libgsasl
		|| (
			$(python_gen_any_dep 'dev-python/twisted[${PYTHON_USEDEP}]')
			$(python_gen_any_dep 'dev-python/twisted-words[${PYTHON_USEDEP}]')
		)
	)
"
# FIXME: needs xmppstream python module
#               >=net-dns/avahi-0.6.22[python]

PATCHES=(
	# Fix uninitialized variable, upstream bug #37701
	"${FILESDIR}"/${PN}-0.5.0-uninitialized.patch
)

python_check_deps() {
	if use test ; then
		 has_version "dev-python/twisted[${PYTHON_USEDEP}]" \
			|| has_version "dev-python/twisted-words[${PYTHON_USEDEP}]"
	fi
}

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
		--docdir=/usr/share/doc/${PF} \
		--with-tls=$(usex gnutls gnutls openssl)
		#$(use_enable test avahi-tests)
}

src_install() {
	MAKEOPTS+=" -j1" default # bug 413581
	find "${D}" -name '*.la' -delete || die
}
