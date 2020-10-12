# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

# Yes, upstream used different version numbers.
# The rockspec version number is 0.7, but the version associated with
# the tarball is 0.07.
MY_PV=0.07

DESCRIPTION="Terminal functions for Lua"
HOMEPAGE="https://github.com/hoelzro/lua-term"
SRC_URI="https://github.com/hoelzro/lua-term/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
RDEPEND=">=dev-lang/lua-5.1:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -fPIC -shared \
		-o core.so core.c"
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -fPIC -shared \
		-o core.so core.c || die
}

src_install() {
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"/term
	doexe core.so
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r term
}
