# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/loudmouth/loudmouth-1.4.3-r2.ebuild,v 1.15 2013/05/15 22:43:30 ssuominen Exp $

EAPI="4"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"
# Not using gnome macro, but behavior is similar, #434736
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="https://github.com/engineyard/loudmouth"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~ppc-macos"

IUSE="asyncns doc ssl static-libs test"

# Automagic libidn dependency
RDEPEND=">=dev-libs/glib-2.4
	net-dns/libidn
	ssl? ( >=net-libs/gnutls-1.4.0 )
	asyncns? ( net-libs/libasyncns )"
# FIXME:
#   openssl dropped because of bug #216705

DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )
	>=dev-util/gtk-doc-am-1"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# Use system libasyncns, bug #236844
	epatch "${FILESDIR}/${P}-asyncns-system.patch"

	# Fix detection of gnutls-2.8, bug #272027
	epatch "${FILESDIR}/${P}-gnutls28.patch"

	# Fix digest auth with SRV (or similar)
	# Upstream: http://loudmouth.lighthouseapp.com/projects/17276-libloudmouth/tickets/44-md5-digest-uri-not-set-correctly-when-using-srv
	epatch "${FILESDIR}/${P}-fix-sasl-md5-digest-uri.patch"

	# Drop stanzas when failing to convert them to LmMessages
	# From debian..
	epatch "${FILESDIR}/${P}-drop-stanzas-on-fail.patch"

	# Don't check for sync dns problems when using asyncns [#33]
	# From debian..
	epatch "${FILESDIR}/${P}-async-fix.patch"

	# Don't append id tag in opening headers [#30]
	epatch "${FILESDIR}/${P}-id-tag-in-opening-headers.patch"

	# Silence chdir, from engineyard git
	epatch "${FILESDIR}/${P}-silence-chdir.patch"

	# Don't free connection internals before connection is closed [#34]
	epatch "${FILESDIR}/${P}-free-before-closed.patch"

	# Check for invalid utf8, bug #389127
	# Upstream: http://loudmouth.lighthouseapp.com/projects/17276/tickets/61
	epatch "${FILESDIR}/${P}-invalid-unicode.patch"

	# http://loudmouth.lighthouseapp.com/projects/17276/tickets/63
	epatch "${FILESDIR}/${P}-glib-2.32.patch"

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467694

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	G2CONF="${G2CONF} $(use_enable static-libs static)"

	if use ssl; then
		G2CONF="${G2CONF} --with-ssl=gnutls"
	else
		G2CONF="${G2CONF} --with-ssl=no"
	fi

	if use asyncns; then
		G2CONF="${G2CONF} --with-asyncns=system"
	else
		G2CONF="${G2CONF} --without-asyncns"
	fi
	gnome2_src_configure
}
