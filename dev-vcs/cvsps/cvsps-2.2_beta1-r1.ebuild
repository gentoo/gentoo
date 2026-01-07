# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

MY_P="${P/_beta/b}"
DESCRIPTION="Generates patchset information from a CVS repository"
HOMEPAGE="http://www.catb.org/~esr/cvsps/"
SRC_URI="http://www.cobite.com/cvsps/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1-build.patch
	"${FILESDIR}"/${P}-solaris.patch
)

src_prepare() {
	default

	# no configure around
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e '/^LDLIBS+=/s/$/ -lsocket/' Makefile || die
	fi
	tc-export CC
}

src_install() {
	dobin cvsps
	doman cvsps.1
	dodoc README CHANGELOG
}
