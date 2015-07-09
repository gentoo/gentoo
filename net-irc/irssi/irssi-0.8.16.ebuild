# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-0.8.16.ebuild,v 1.15 2015/07/09 19:49:57 swegener Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils flag-o-matic perl-module toolchain-funcs

# Keep for _rc compability
MY_P="${P/_/-}"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
SRC_URI="http://irssi.org/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ipv6 +perl selinux ssl socks5 +proxy"

CDEPEND="sys-libs/ncurses
	>=dev-libs/glib-2.6.0
	ssl? ( dev-libs/openssl:= )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.8.15-tinfo.patch"
	sed -e "s@pkg-config@$(tc-getPKG_CONFIG)@g" \
		-i "${S}/curses.m4" \
		|| die "Could not configure pkg-config in curses.m4"
	autotools-utils_src_prepare
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

	dodoc AUTHORS ChangeLog README TODO NEWS
}
