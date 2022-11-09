# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A download utility with segmented downloading with BitTorrent support"
HOMEPAGE="https://aria2.github.io/"
SRC_URI="https://github.com/aria2/${PN}/releases/download/release-${PV}/${P}.tar.xz"

LICENSE="GPL-2+-with-openssl-exception"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="
	adns bittorrent +gnutls jemalloc libuv +libxml2 metalink +nettle
	nls sqlite scripts ssh ssl tcmalloc test xmlrpc
"
# xmlrpc has no explicit switch, it's turned out by any XML library
# so metalink implicitly forces it on
REQUIRED_USE="
	?? ( jemalloc tcmalloc )
	metalink? ( xmlrpc )
"
RESTRICT="!test? ( test )"

# Crazy GnuTLS/OpenSSL/etc. logic below:
# 1. Those libraries are used for two purposes: TLS & MD.
# 2. Upstream preferences are:
#    1) gnutls [tls]
#    2) !gnutls? -> openssl [tls+md]
#    3) !openssl? -> nettle [md]
#    4) !openssl? !nettle? -> gcrypt [md]
#    5) !*? -> bundled md routines (we don't use them)
# 3. There's also gmp usage for bittorrent with nettle.
# 4. You can't really control features, just dependencies.
# (we are skipping native Apple/Windows TLS support)
#
# We map this into:
# ssl? -> openssl || (gnutls + (nettle || libgcrypt ))
# !ssl? -> nettle || libgcrypt
RDEPEND="
	sys-libs/zlib:0=
	adns? ( >=net-dns/c-ares-1.5.0:0= )
	jemalloc? ( dev-libs/jemalloc )
	libuv? ( >=dev-libs/libuv-1.13:0= )
	metalink? (
		libxml2? ( >=dev-libs/libxml2-2.6.26:2= )
		!libxml2? ( dev-libs/expat:0= )
	)
	sqlite? ( dev-db/sqlite:3= )
	ssh? ( net-libs/libssh2:= )
	ssl? (
		app-misc/ca-certificates
		gnutls? (
			>=net-libs/gnutls-1.2.9:0=
			nettle? (
				>=dev-libs/nettle-2.4:0=
				bittorrent? (
					>=dev-libs/nettle-2.4:0=[gmp]
					>=dev-libs/gmp-6:0=
				)
			)
			!nettle? ( >=dev-libs/libgcrypt-1.2.2:0= )
		)
		!gnutls? (
			dev-libs/openssl:0=
		)
	)
	!ssl? (
		nettle? (
			>=dev-libs/nettle-2.4:0=
			bittorrent? (
				>=dev-libs/nettle-2.4:0=[gmp]
				>=dev-libs/gmp-6:0=
			)
		)
		!nettle? ( >=dev-libs/libgcrypt-1.2.2:0= )
	)
	tcmalloc? ( dev-util/google-perftools )
	xmlrpc? (
		libxml2? ( >=dev-libs/libxml2-2.6.26:2= )
		!libxml2? ( dev-libs/expat:0= )
	)
"

DEPEND="
	${RDEPEND}
	test? ( >=dev-util/cppunit-1.12.0:0 )
"
RDEPEND+="
	nls? ( virtual/libiconv virtual/libintl )
	scripts? ( dev-lang/ruby )
"
BDEPEND="app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	if use scripts && ! use xmlrpc; then
		ewarn "Please note that you may need to enable USE=xmlrpc to run the aria2rpc"
		ewarn "and aria2mon scripts against the local aria2."
	fi
}

src_prepare() {
	default
	sed -i -e "s|/tmp|${T}|" test/*.cc test/*.txt || die "sed failed"
	# Fails with USE=bittorrent && FEATURES=network-sandbox
	sed -i -E \
		-e '/^@ENABLE_BITTORRENT_TRUE@	LpdMessageDispatcherTest/d' \
		-e '/^@ENABLE_BITTORRENT_TRUE@	LpdMessageReceiverTest/d' \
		test/Makefile.in || die
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
		$(use_with adns libcares)
		$(use_with jemalloc)
		$(use_with libuv)
		$(use_with sqlite sqlite3)
		$(use_with ssh libssh2)
		$(use_with tcmalloc)

		# forces bundled wslay
		--disable-websocket
	)

	# See TLS/MD logic described above deps.
	if use ssl && ! use gnutls; then
		# 1. if ssl & !gnutls, use openssl and disable gnutls
		myconf+=( --without-gnutls --with-openssl )
	else
		myconf+=(
			# 2. otherwise, disable openssl
			--without-openssl
			# 3. if ssl & gnutls, use gnutls
			$(use_with ssl gnutls)

			# 4. switch between nettle & libgcrypt
			$(use_with nettle libnettle)
			$(use_with !nettle libgcrypt)
		)

		# 5. if bittorrent is used along with nettle, use libgmp
		if use bittorrent && use nettle; then
			myconf+=( --with-libgmp )
		else
			myconf+=( --without-libgmp )
		fi
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
	rm -r "${ED}"/usr/share/doc/${PF}/README{,.html} || die

	dobashcomp doc/bash_completion/aria2c
	use scripts && dobin doc/xmlrpc/aria2{mon,rpc}
}

pkg_postinst() {
	if use xmlrpc; then
		elog "If you would like to use the additional aria2mon and aria2rpc tools,"
		elog "you need to have \033[1mdev-lang/ruby\033[0m installed."
	fi
}
