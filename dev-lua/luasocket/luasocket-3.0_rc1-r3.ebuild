# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib multilib-minimal flag-o-matic

DESCRIPTION="Networking support library for the Lua language"
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
SRC_URI="https://github.com/diegonehab/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 sparc x86"
IUSE="debug"

RDEPEND=">=dev-lang/lua-5.1.5-r2[deprecated,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

S=${WORKDIR}/${PN}-${PV/_/-}

RESTRICT="test"

src_prepare() {
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
		LUAPREFIX_linux=/usr \
		LUAV=${luav} \
		CDIR_linux=$(get_libdir)/lua/${luav} \
		install-unix
}

multilib_src_install_all() {
	dodoc NEW README
	dohtml -r doc/.
}
