# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools perl-module git-r3

EGIT_REPO_URI="git://github.com/irssi/irssi.git"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+perl selinux ssl socks5 +proxy libressl"

CDEPEND="sys-libs/ncurses:0=
	>=dev-libs/glib-2.6.0
	ssl? (
		!libressl? ( dev-libs/openssl:= )
		libressl? ( dev-libs/libressl:= )
	)
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"

DEPEND="
	${CDEPEND}
	virtual/pkgconfig
	dev-lang/perl
	|| (
		www-client/lynx
		www-client/elinks
	)"

RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

src_prepare() {
	sed -i -e /^autoreconf/d autogen.sh || die
	NOCONFIGURE=1 ./autogen.sh || die

	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		--with-ncurses="${EPREFIX}"/usr \
		--with-perl-lib=vendor \
		--enable-static \
		--enable-true-color \
		$(use_with proxy) \
		$(use_with perl) \
		$(use_with socks5 socks) \
		$(use_enable ssl)
}

src_install() {
	emake DESTDIR="${D}" install

	use perl && perl_delete_localpod

	prune_libtool_files --modules

	dodoc AUTHORS ChangeLog README.md TODO NEWS
}
