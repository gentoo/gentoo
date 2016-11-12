# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit bash-completion-r1

DESCRIPTION="A download utility with segmented downloading with BitTorrent support"
HOMEPAGE="https://aria2.github.io/"
SRC_URI="https://github.com/aria2/${PN}/releases/download/release-${PV}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="adns bittorrent +gnutls jemalloc libuv +libxml2 metalink +nettle nls sqlite scripts ssh ssl tcmalloc test xmlrpc"

CDEPEND="sys-libs/zlib:0=
	ssl? (
		app-misc/ca-certificates
		gnutls? ( >=net-libs/gnutls-1.2.9:0= )
		!gnutls? ( dev-libs/openssl:0= ) )
	adns? ( >=net-dns/c-ares-1.5.0:0= )
	bittorrent? (
		ssl? (
			gnutls? (
				nettle? ( >=dev-libs/nettle-2.4:0=[gmp] >=dev-libs/gmp-5:0= )
				!nettle? ( >=dev-libs/libgcrypt-1.2.2:0= ) ) )
		!ssl? (
			nettle? ( >=dev-libs/nettle-2.4:0=[gmp] >=dev-libs/gmp-5:0= )
			!nettle? ( >=dev-libs/libgcrypt-1.2.2:0= ) ) )
	jemalloc? ( dev-libs/jemalloc )
	libuv? ( dev-libs/libuv:0= )
	metalink? (
		libxml2? ( >=dev-libs/libxml2-2.6.26:2= )
		!libxml2? ( dev-libs/expat:0= ) )
	sqlite? ( dev-db/sqlite:3= )
	ssh? ( net-libs/libssh2:= )
	tcmalloc? ( dev-util/google-perftools )
	xmlrpc? (
		libxml2? ( >=dev-libs/libxml2-2.6.26:2= )
		!libxml2? ( dev-libs/expat:0= ) )"

DEPEND="${CDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.12.0:0 )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libiconv virtual/libintl )
	scripts? ( dev-lang/ruby )"

REQUIRED_USE="jemalloc? ( !tcmalloc )
	tcmalloc? ( !jemalloc )"
RESTRICT="!test? ( test )"

pkg_setup() {
	if use scripts && use !xmlrpc && use !metalink; then
		ewarn "Please note that you may need to enable USE=xmlrpc to run the aria2rpc"
		ewarn "and aria2mon scripts against the local aria2."
	fi
}

src_prepare() {
	default
	sed -i -e "s|/tmp|${T}|" test/*.cc test/*.txt || die "sed failed"
}

src_configure() {
	local myconf=(
		# threads, epoll: check for best portability

		# do not try to compile and run a test LIBXML program
		--disable-xmltest
		# enable the shared library
		--enable-libaria2
		# zlib should always be available anyway
		--with-libz
		--with-ca-bundle="${EPREFIX}/etc/ssl/certs/ca-certificates.crt"

		# optional features
		$(use_enable bittorrent)
		$(use_enable metalink)
		$(use_enable nls)
		$(use_with sqlite sqlite3)
		$(use_with adns libcares)
		$(use_with libuv)
		$(use_with jemalloc)
		$(use_with tcmalloc)
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
