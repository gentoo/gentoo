# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT_AUX="8d09895473b73e4fb72b7573615f69c36e1860a2"
MY_PN_AUX="lua-auxiliar"
MY_PN_COMPAT="lua-compat-5.3"
MY_PV="${PV//_p/-}"
MY_PV_COMPAT="0.10"

inherit toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
SRC_URI="
	https://github.com/zhaozg/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zhaozg/${MY_PN_AUX}/archive/${EGIT_COMMIT_AUX}.tar.gz -> ${MY_PN_AUX}-${EGIT_COMMIT_AUX}.tar.gz
	https://github.com/keplerproject/${MY_PN_COMPAT}/archive/v${MY_PV_COMPAT}.tar.gz -> ${MY_PN_COMPAT}-${MY_PV_COMPAT}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libressl luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-lua/luaossl
	!dev-lua/luasec
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

DOCS=( "README.md" "samples/." )

src_prepare() {
	default

	# Prepare needed dependencies (source code files only)
	rm -r deps/{auxiliar,lua-compat} || die
	mv "${WORKDIR}/${MY_PN_AUX}-${EGIT_COMMIT_AUX}" deps/auxiliar || die
	mv "${WORKDIR}/${MY_PN_COMPAT}-${MY_PV_COMPAT}" deps/lua-compat || die
}

src_compile() {
	local myemakeargs=(
		"AR=$(tc-getAR)"
		"CC=$(tc-getCC)"
		"LUA_CFLAGS=${CFLAGS} -I$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
		"LUA_LIBS=${LDFLAGS}"
		"LUA_VERSION=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'abiver' 'V') $(usex luajit 'luajit' 'lua'))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	local myemakeargs=(
		"LUA=$(usex luajit 'luajit' 'lua')"
		"LUA_VERSION=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'abiver' 'V') $(usex luajit 'luajit' 'lua'))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}" test
}

src_install() {
	local myemakeargs=(
		"LUA_LIBDIR=${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"LUA_VERSION=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'abiver' 'V') $(usex luajit 'luajit' 'lua'))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}" install

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	doins -r "lib/."

	einstalldocs
}
