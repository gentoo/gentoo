# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles toolchain-funcs

DESCRIPTION="Prosody is a modern XMPP communication server"
HOMEPAGE="https://prosody.im/"
SRC_URI="https://prosody.im/downloads/source/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+libevent libressl luajit mysql postgres +sqlite +ssl test +zlib"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	|| (
		>=dev-lang/lua-5.2:*
		dev-lua/lua-bit32
	)
	net-dns/libidn
	net-im/jabber-base
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"

DEPEND="
	${COMMON_DEPEND}
	test? ( dev-lua/busted )
"

RDEPEND="
	${COMMON_DEPEND}
	dev-lua/luaexpat
	dev-lua/luafilesystem
	dev-lua/luasocket
	libevent? ( dev-lua/luaevent )
	mysql? ( dev-lua/luadbi[mysql] )
	postgres? ( dev-lua/luadbi[postgres] )
	sqlite? ( dev-lua/luadbi[sqlite] )
	ssl? ( dev-lua/luasec )
	zlib? ( dev-lua/lua-zlib )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.11.7-bit32.patch"
	"${FILESDIR}/${PN}-0.11.7-gentoo.patch"
)

src_prepare() {
	default

	# Set correct plugin path for optional net-im/prosody-modules package
	sed -e "s/GENTOO_LIBDIR/$(get_libdir)/g" -i prosody.cfg.lua.dist || die
}

src_configure() {
	local myeconfargs=(
		--c-compiler="$(tc-getCC)"
		--datadir="${EPREFIX}/var/spool/jabber"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--linker="$(tc-getCC)"
		--ostype="linux"
		--prefix="${EPREFIX}/usr"
		--runwith="$(usex luajit luajit lua)"
		--sysconfdir="${EPREFIX}/etc/jabber"
		--with-lua-include="${EPREFIX}/usr/include"
		--with-lua-lib="${EPREFIX}/usr/$(get_libdir)/lua"
	)

	# Since the configure script is handcrafted,
	# and yells at unknown options, do not use 'econf'.
	./configure ${myeconfargs[@]} --cflags="${CFLAGS} -Wall -fPIC" --ldflags="${LDFLAGS} -shared" || die

	rm makefile || die
	mv GNUmakefile Makefile || die
}

src_install() {
	default

	newinitd "${FILESDIR}"/prosody.initd-r4 prosody
	systemd_newunit "${FILESDIR}"/prosody.service-r2 prosody.service

	newtmpfiles "${FILESDIR}"/prosody.tmpfilesd-r1 prosody.conf

	keepdir /var/spool/jabber
}

pkg_postinst() {
	tmpfiles_process prosody.conf
}
