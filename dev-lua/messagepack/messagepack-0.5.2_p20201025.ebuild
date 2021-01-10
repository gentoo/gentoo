# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="18f316b3f62c02bf2b7a3096701780f78a4d2c67"
MY_PN="lua-MessagePack"
MY_P="${MY_PN}-${EGIT_COMMIT}"

inherit toolchain-funcs

DESCRIPTION="A pure Lua implementation of the MessagePack serialization format"
HOMEPAGE="https://fperrad.frama.io/lua-MessagePack"
SRC_URI="https://framagit.org/fperrad/${MY_PN}/-/archive/${EGIT_COMMIT}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit test"

# Needed 'lua-TestMore' Lua module not in tree
RESTRICT="test"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"

BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

src_compile() {
	:;
}

src_install() {
	local myemakeargs=(
		"LIBDIR=${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"LUAVER=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'abiver' 'V') $(usex luajit 'luajit' 'lua'))"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
