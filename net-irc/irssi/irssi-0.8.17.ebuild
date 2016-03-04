# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ipv6 +perl selinux ssl socks5 +proxy libressl"

CDEPEND="sys-libs/ncurses:0=
	>=dev-libs/glib-2.6.0
	ssl? ( !libressl? ( dev-libs/openssl:= ) libressl? ( dev-libs/libressl:= ) )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"

DEPEND="
	${CDEPEND}
	virtual/pkgconfig"

RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	pushd m4 > /dev/null || die
	epatch "${FILESDIR}/${PN}-0.8.15-tinfo.patch"
	popd > /dev/null || die
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

	dodoc AUTHORS ChangeLog README.md TODO NEWS
}
