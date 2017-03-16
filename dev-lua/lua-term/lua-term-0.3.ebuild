# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

# Yes, upstream used different version numbers.
# The rockspec version number is 0.3, but the version associated with
# the tarball is 0.03.
MY_PV=0.03

DESCRIPTION="Terminal functions for Lua"
HOMEPAGE="https://github.com/hoelzro/lua-term"
SRC_URI="https://github.com/hoelzro/lua-term/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

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
