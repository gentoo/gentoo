# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit bash-completion-r1 eutils

DESCRIPTION="A download utility with segmented downloading with BitTorrent support"
HOMEPAGE="http://aria2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
SLOT="0"
IUSE="adns bittorrent +gnutls +libxml2 metalink +nettle nls sqlite scripts ssl test xmlrpc"

CDEPEND="sys-libs/zlib
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.2.9 )
		!gnutls? ( dev-libs/openssl ) )
	adns? ( >=net-dns/c-ares-1.5.0 )
	bittorrent? (
		ssl? (
			gnutls? (
				nettle? ( >=dev-libs/nettle-2.4[gmp] >=dev-libs/gmp-5 )
				!nettle? ( >=dev-libs/libgcrypt-1.2.2:0 ) ) )
		!ssl? (
			nettle? ( >=dev-libs/nettle-2.4[gmp] >=dev-libs/gmp-5 )
			!nettle? ( >=dev-libs/libgcrypt-1.2.2:0 ) ) )
	metalink? (
		libxml2? ( >=dev-libs/libxml2-2.6.26 )
		!libxml2? ( dev-libs/expat ) )
	sqlite? ( dev-db/sqlite:3 )
	xmlrpc? (
		libxml2? ( >=dev-libs/libxml2-2.6.26 )
		!libxml2? ( dev-libs/expat ) )"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.12.0 )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libiconv virtual/libintl )
	scripts? ( dev-lang/ruby )"

pkg_setup() {
	if use scripts && use !xmlrpc && use !metalink; then
		ewarn "Please note that you may need to enable USE=xmlrpc to run the aria2rpc"
		ewarn "and aria2mon scripts against the local aria2."
	fi
}

src_prepare() {
	epatch_user
	sed -i -e "s|/tmp|${T}|" test/*.cc test/*.txt || die "sed failed"
}

src_configure() {
	# Notes:
	# - always enable gzip/http compression since zlib should always be available anyway
	# - always enable epoll since we can assume kernel 2.6.x
	# - other options for threads: solaris, pth, win32
	local myconf=(
		--enable-epoll
		--enable-threads=posix
		--with-libz
		$(use_enable nls)
		$(use_enable metalink)
		$(use_with sqlite sqlite3)
		$(use_enable bittorrent)
		$(use_with adns libcares)
	)

	# SSL := gnutls / openssl
	# USE=ssl
	#  + USE=gnutls -> gnutls
	#  + USE=-gnutls -> openssl

	if use ssl; then
		myconf+=( $(use_with gnutls) $(use_with !gnutls openssl) )
	else
		myconf+=( --without-gnutls --without-openssl )
	fi

	# message-digest := nettle / gcrypt / openssl
	# bignum := nettle+gmp / gcrypt / openssl
	# bittorrent := message-digest + bignum
	# USE=bittorrent
	#  + USE=(ssl -gnutls) -> openssl
	#  + USE=nettle -> nettle+gmp
	#  + USE=-nettle -> gcrypt

	if use !bittorrent || use ssl && use !gnutls; then
		myconf+=( --without-libgcrypt --without-libnettle --without-libgmp )
	else
		myconf+=( $(use_with !nettle libgcrypt)
			$(use_with nettle libnettle) $(use_with nettle libgmp) )
	fi

	# metalink+xmlrpc := libxml2 / expat
	# USE=(metalink || xmlrpc)
	#  + USE=libxml2 -> libxml2
	#  + USE=-libxml2 -> expat

	if use metalink || use xmlrpc; then
		myconf+=( $(use_with !libxml2 libexpat) $(use_with libxml2) )
	else
		myconf+=( --without-libexpat --without-libxml2 )
	fi

	# Note:
	# - always enable gzip/http compression since zlib should always be available anyway
	# - always enable epoll since we can assume kernel 2.6.x
	# - other options for threads: solaris, pth, win32
	econf "${myconf[@]}"
}

src_install() {
	default
	rm -rf "${D}"/usr/share/doc/aria2 \
		"${D}"/usr/share/doc/${PF}/README{,.html}

	dobashcomp doc/bash_completion/aria2c
	use scripts && dobin doc/xmlrpc/aria2{mon,rpc}
}

pkg_postinst() {
	if use xmlrpc || use metalink; then
		elog "If you would like to use the additional aria2mon and aria2rpc tools,"
		elog "you need to have \033[1mdev-lang/ruby\033[0m installed."
	fi
}
