# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

# The below is the upstream version number. The -x suffix should be kept
# in sync with the _px suffix in the ebuild version.
MY_PV="0.2.0-0"

DESCRIPTION="platform independent system calls for lua"
HOMEPAGE="https://github.com/LuaDist2/luasystem"
SRC_URI="https://github.com/LuaDist2/luasystem/archive/${MY_PV}.tar.gz ->
	${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" MYCFLAGS="${CFLAGS}" \
		LD="$(tc-getCC)" MYLDFLAGS="${LDFLAGS}"
}

src_install () {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r system
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"/system
	doexe src/core.so
dodoc README.md
}
