# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib systemd

MY_PV=$(ver_rs 3 '')
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Prosody is a flexible communications server for Jabber/XMPP written in Lua"
HOMEPAGE="https://prosody.im/"
SRC_URI="https://prosody.im/tmp/${MY_PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="ipv6 libevent mysql postgres sqlite ssl zlib jit libressl test"

BASE_DEPEND="net-im/jabber-base
		dev-lua/LuaBitOp
		!jit? ( >=dev-lang/lua-5.1:0 )
		jit? ( dev-lang/luajit:2 )
		>=net-dns/libidn-1.1:=
		!libressl? ( dev-libs/openssl:0 ) libressl? ( dev-libs/libressl:= )"

DEPEND="${BASE_DEPEND}
		test? ( dev-lua/busted )"

RDEPEND="${BASE_DEPEND}
		>=dev-lua/luaexpat-1.3.0
		dev-lua/luafilesystem
		ipv6? ( >=dev-lua/luasocket-3 )
		!ipv6? ( dev-lua/luasocket )
		libevent? ( >=dev-lua/luaevent-0.4.3 )
		mysql? ( dev-lua/luadbi[mysql] )
		postgres? ( dev-lua/luadbi[postgres] )
		sqlite? ( dev-lua/luadbi[sqlite] )
		ssl? ( dev-lua/luasec )
		zlib? ( dev-lua/lua-zlib )"

S=${WORKDIR}/${MY_P}

JABBER_ETC="/etc/jabber"
JABBER_SPOOL="/var/spool/jabber"

src_prepare() {
	default
	rm makefile && mv GNUmakefile Makefile || die
	sed -i -e "s!MODULES = \$(DESTDIR)\$(PREFIX)/lib/!MODULES = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!"\
		-e "s!SOURCE = \$(DESTDIR)\$(PREFIX)/lib/!SOURCE = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!"\
		-e "s!INSTALLEDSOURCE = \$(PREFIX)/lib/!INSTALLEDSOURCE = \$(PREFIX)/$(get_libdir)/!"\
		-e "s!INSTALLEDMODULES = \$(PREFIX)/lib/!INSTALLEDMODULES = \$(PREFIX)/$(get_libdir)/!"\
		Makefile || die
}

src_configure() {
	# the configure script is handcrafted (and yells at unknown options)
	# hence do not use 'econf'
	append-cflags -D_GNU_SOURCE
	./configure \
		--ostype=linux \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--sysconfdir="${EPREFIX}/${JABBER_ETC}" \
		--datadir="${EPREFIX}/${JABBER_SPOOL}" \
		--with-lua-include="${EPREFIX}/usr/include" \
		--with-lua-lib="${EPREFIX}/usr/$(get_libdir)/lua" \
		--runwith=lua"$(usev jit)" \
		--cflags="${CFLAGS} -Wall -fPIC" \
		--ldflags="${LDFLAGS} -shared" \
		--c-compiler="$(tc-getCC)" \
		--linker="$(tc-getCC)" || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install
	systemd_dounit "${FILESDIR}/${PN}".service
	systemd_newtmpfilesd "${FILESDIR}/${PN}".tmpfilesd "${PN}".conf
	newinitd "${FILESDIR}/${PN}".initd-r2 ${PN}
	keepdir "${JABBER_SPOOL}"
}

pkg_postinst() {
	elog "If you are using the MySQL backend, you need to update its schema:"
	elog "https://prosody.im/doc/release/0.11.0#upgrade_notes"
}
