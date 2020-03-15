# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="Parallel bzip2 (de)compressor using libbz2"
HOMEPAGE="http://compression.ca/pbzip2/ https://launchpad.net/pbzip2"
SRC_URI="https://launchpad.net/pbzip2/${PV:0:3}/${PV}/+download/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static symlink"

LIB_DEPEND="app-arch/bzip2[static-libs(+)]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	symlink? ( !app-arch/lbzip2[symlink] )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

src_prepare() {
	# https://bugs.launchpad.net/pbzip2/+bug/1746369
	sed -i 's:"PRIuMAX":" PRIuMAX ":g' *.cpp || die
	epatch "${FILESDIR}"/${PN}-1.1.10-makefile.patch
	tc-export CXX
	use static && append-ldflags -static
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS ChangeLog README

	if use symlink ; then
		local s
		for s in bzip2 bunzip2 bzcat ; do
			dosym pbzip2 /usr/bin/${s}
		done
	fi
}
