# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal flag-o-matic toolchain-funcs

DESCRIPTION="Networking support library for the Lua language"
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/
	https://github.com/diegonehab/luasocket"
SRC_URI="https://github.com/diegonehab/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~mips ppc ppc64 sparc x86"
IUSE="debug"

RDEPEND=">=dev-lang/lua-5.1.5-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${PN}-${PV/_/-}

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/proxy-fix.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		CC="$(tc-getCC) ${CFLAGS}" \
		LD="$(tc-getCC) ${LDFLAGS}"\
		$(usex debug DEBUG="DEBUG" "")
}

multilib_src_install() {
	local luav=$($(tc-getPKG_CONFIG) --variable V lua)
	emake \
		DESTDIR="${D}" \
		LUAPREFIX_linux="${EPREFIX}/usr" \
		LUAV=${luav} \
		CDIR_linux=$(get_libdir)/lua/${luav} \
		install-unix
	insinto /usr/include/lua${luav}/luasocket
	doins src/*.h
}

multilib_src_install_all() {
	dodoc NEW README
	docinto html
	dodoc -r doc/.
}
