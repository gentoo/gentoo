# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-9999.ebuild,v 1.15 2015/07/09 19:49:57 swegener Exp $

EAPI=5

inherit autotools perl-module git-r3

EGIT_REPO_URI="git://github.com/irssi/irssi.git"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ipv6 +perl selinux ssl socks5 +proxy"

CDEPEND="sys-libs/ncurses
	>=dev-libs/glib-2.6.0
	ssl? ( dev-libs/openssl:= )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	>=sys-devel/autoconf-2.58
	dev-lang/perl
	|| (
		www-client/lynx
		www-client/elinks
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

src_prepare() {
	sed -i -e /^autoreconf/d autogen.sh || die
	NOCONFIGURE=1 ./autogen.sh || die

	eautoreconf
}

src_configure() {
	econf \
		--with-ncurses="${EPREFIX}"/usr \
		--with-perl-lib=vendor \
		--enable-static \
		$(use_with proxy) \
		$(use_with perl) \
		$(use_with socks5 socks) \
		$(use_enable ssl) \
		$(use_enable ipv6)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	use perl && perl_delete_localpod

	prune_libtool_files --modules

	dodoc AUTHORS ChangeLog README.md TODO NEWS
}
