# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-rel-${PV}"

inherit toolchain-funcs

DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe"
HOMEPAGE="https://github.com/wahern/luaossl"
SRC_URI="https://github.com/wahern/${PN}/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="examples luajit"

RDEPEND="
	dev-libs/openssl:0[-bindist]
	!dev-lua/lua-openssl
	!dev-lua/luasec
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "doc/." )

src_prepare() {
	default

	# Remove Lua autodetection
	# Respect users CFLAGS
	sed -e '/LUAPATH :=/d' -e '/LUAPATH_FN =/d' -e '/HAVE_API_FN =/d' -e '/WITH_API_FN/d' -e 's/-O2//g' -i GNUmakefile || die

	# Set LUA version
	LUA_VERSION=$($(tc-getPKG_CONFIG) --variable=$(usex luajit abiver V) $(usex luajit luajit lua))
}

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"ALL_CPPFLAGS=${CPPFLAGS} -I$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
		"libdir="
	)

	emake "${myemakeargs[@]}" openssl${LUA_VERSION}
}

src_install() {
	local myemakeargs=(
		"DESTDIR=${D}"
		"lua${LUA_VERSION/./}cpath=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"lua${LUA_VERSION/./}path=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"prefix=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install${LUA_VERSION}

	use examples && dodoc -r "examples/."

	einstalldocs
}
