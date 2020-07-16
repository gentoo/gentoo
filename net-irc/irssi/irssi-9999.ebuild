# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

GENTOO_DEPEND_ON_PERL="no"

inherit autotools perl-module git-r3

EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="https://irssi.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="otr +perl selinux socks5 +proxy libressl"

COMMON_DEPEND="sys-libs/ncurses:0=
	>=dev-libs/glib-2.6.0
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	otr? (
		>=dev-libs/libgcrypt-1.2.0:0=
		>=net-libs/libotr-4.1.0
	)
	perl? ( dev-lang/perl:= )
	socks5? ( >=net-proxy/dante-1.1.18 )"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
	dev-lang/perl
	|| (
		www-client/lynx
		www-client/elinks
	)"

RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-irc )"

src_prepare() {
	sed -i -e /^autoreconf/d autogen.sh || die
	NOCONFIGURE=1 ./autogen.sh || die

	default
	eautoreconf
}

src_configure() {
	# Disable automagic dependency on dev-libs/libutf8proc (bug #677804)
	export ac_cv_lib_utf8proc_utf8proc_version=no

	local myeconfargs=(
		--with-perl-lib=vendor
		--enable-true-color
		$(use_with otr)
		$(use_with proxy)
		$(use_with perl)
		$(use_with socks5 socks)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use perl && perl_delete_localpod

	rm -f "${ED}"/usr/$(get_libdir)/irssi/modules/*.{a,la} || die

	dodoc AUTHORS ChangeLog README.md TODO NEWS
}
