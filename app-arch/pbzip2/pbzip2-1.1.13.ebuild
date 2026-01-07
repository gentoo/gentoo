# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Parallel bzip2 (de)compressor using libbz2"
HOMEPAGE="http://compression.ca/pbzip2/ https://launchpad.net/pbzip2"
SRC_URI="https://launchpad.net/pbzip2/${PV:0:3}/${PV}/+download/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static"

LIB_DEPEND="app-arch/bzip2[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.10-makefile.patch
)

src_prepare() {
	default
	# https://bugs.launchpad.net/pbzip2/+bug/1746369
	sed -i 's:"PRIuMAX":" PRIuMAX ":g' *.cpp || die
}

src_configure() {
	tc-export CXX
	use static && append-ldflags -static
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS ChangeLog README
}
