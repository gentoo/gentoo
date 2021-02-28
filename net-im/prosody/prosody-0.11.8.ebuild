# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )
LUA_REQ_USE="deprecated(+)"

inherit lua-single systemd tmpfiles toolchain-funcs

DESCRIPTION="Prosody is a modern XMPP communication server"
HOMEPAGE="https://prosody.im/"
SRC_URI="https://prosody.im/downloads/source/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86"
IUSE="icu +idn +libevent libressl mysql postgres selinux +sqlite +ssl test +zlib"
REQUIRED_USE="
	^^ ( icu idn )
	${LUA_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

DEPEND="
	$(lua_gen_cond_dep 'dev-lua/luaexpat[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/luafilesystem[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/luasocket[${LUA_USEDEP}]')
	net-im/jabber-base
	icu? ( dev-libs/icu:= )
	idn? ( net-dns/libidn:= )
	libevent? ( $(lua_gen_cond_dep 'dev-lua/luaevent[${LUA_USEDEP}]') )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	lua_single_target_lua5-1? ( $(lua_gen_cond_dep 'dev-lua/lua-bit32[lua_targets_lua5-1(-)]') )
	mysql? ( $(lua_gen_cond_dep 'dev-lua/luadbi[mysql,${LUA_USEDEP}]') )
	postgres? ( $(lua_gen_cond_dep 'dev-lua/luadbi[postgres,${LUA_USEDEP}]') )
	sqlite? ( $(lua_gen_cond_dep 'dev-lua/luadbi[sqlite,${LUA_USEDEP}]') )
	ssl? ( $(lua_gen_cond_dep 'dev-lua/luasec[${LUA_USEDEP}]') )
	zlib? ( $(lua_gen_cond_dep 'dev-lua/lua-zlib[${LUA_USEDEP}]') )
	${LUA_DEPS}
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-jabber )
"

BDEPEND="
	virtual/pkgconfig
	test? ( $(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]') )
"

PATCHES=( "${FILESDIR}/${PN}-0.11.7-gentoo.patch" )

src_prepare() {
	default

	# Set correct plugin path for optional net-im/prosody-modules package
	sed -e "s/GENTOO_LIBDIR/$(get_libdir)/g" -i prosody.cfg.lua.dist || die
}

src_configure() {
	local myeconfargs=(
		--add-cflags="${CFLAGS}"
		--add-ldflags="${LDFLAGS}"
		--c-compiler="$(tc-getCC)"
		--datadir="${EPREFIX}/var/spool/jabber"
		--idn-library="$(usex idn 'idn' 'icu')"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--linker="$(tc-getCC)"
		--lua-version="$(usex lua_single_target_luajit '5.1' $(ver_cut 1-2 $(lua_get_version)))"
		--no-example-certs
		--ostype="linux"
		--prefix="${EPREFIX}/usr"
		--runwith="${ELUA}"
		--sysconfdir="${EPREFIX}/etc/jabber"
		--with-lua-include="${EPREFIX}/$(lua_get_include_dir)"
		--with-lua-lib="${EPREFIX}/$(lua_get_cmod_dir)"
	)

	# Since the configure script is handcrafted,
	# and yells at unknown options, do not use 'econf'.
	./configure "${myeconfargs[@]}" || die

	rm makefile || die
	mv GNUmakefile Makefile || die
}

src_install() {
	default

	keepdir /var/spool/jabber

	newinitd "${FILESDIR}"/prosody.initd-r5 prosody
	systemd_newunit "${FILESDIR}"/prosody.service-r2 prosody.service

	newtmpfiles "${FILESDIR}"/prosody.tmpfilesd-r1 prosody.conf
}

pkg_postinst() {
	tmpfiles_process prosody.conf
}
