# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib systemd toolchain-funcs

DESCRIPTION="Prosody is a flexible communications server for Jabber/XMPP written in Lua"
HOMEPAGE="https://prosody.im/"
SRC_URI="https://prosody.im/downloads/source/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="ipv6 jit libevent libressl mysql postgres sqlite ssl test zlib"
RESTRICT="!test? ( test )"

BASE_DEPEND="net-im/jabber-base
		dev-lua/LuaBitOp
		!jit? ( >=dev-lang/lua-5.1:0 )
		jit? ( dev-lang/luajit:2 )
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl:= )
		>=net-dns/libidn-1.1:="

DEPEND="${BASE_DEPEND}
		test? ( dev-lua/busted )"

RDEPEND="${BASE_DEPEND}
		>=dev-lua/luaexpat-1.3.0
		dev-lua/luafilesystem
		!ipv6? ( dev-lua/luasocket )
		ipv6? ( >=dev-lua/luasocket-3 )
		libevent? ( >=dev-lua/luaevent-0.4.3 )
		mysql? ( dev-lua/luadbi[mysql] )
		postgres? ( dev-lua/luadbi[postgres] )
		sqlite? ( dev-lua/luadbi[sqlite] )
		ssl? ( dev-lua/luasec )
		zlib? ( dev-lua/lua-zlib )"

PATCHES=("${FILESDIR}/prosody_cfg-0.11.2-r1.patch")

JABBER_ETC="/etc/jabber"
JABBER_SPOOL="/var/spool/jabber"

src_configure() {
	# the configure script is handcrafted (and yells at unknown options)
	# hence do not use 'econf'
	./configure \
		--ostype=linux \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--sysconfdir="${EPREFIX}${JABBER_ETC}" \
		--datadir="${EPREFIX}${JABBER_SPOOL}" \
		--with-lua-include="${EPREFIX}/usr/include" \
		--with-lua-lib="${EPREFIX}/usr/$(get_libdir)/lua" \
		--runwith=lua"$(usev jit)" \
		--cflags="${CFLAGS} -Wall -fPIC" \
		--ldflags="${LDFLAGS} -shared" \
		--c-compiler="$(tc-getCC)" \
		--linker="$(tc-getCC)" || die "configure failed"

	rm makefile && mv GNUmakefile Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install
	systemd_dounit "${FILESDIR}/${PN}".service
	systemd_newtmpfilesd "${FILESDIR}/${PN}".tmpfilesd "${PN}".conf
	newinitd "${FILESDIR}/${PN}".initd-r2 ${PN}
	keepdir "${JABBER_SPOOL}"
}
