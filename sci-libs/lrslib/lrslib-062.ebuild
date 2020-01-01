# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="Self-contained C implementation of the reverse search algorithm"
HOMEPAGE="http://cgm.cs.mcgill.ca/~avis/C/lrs.html"
SRC_URI="http://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="gmp mpi"

RDEPEND="gmp? ( dev-libs/gmp:0=
			  mpi? ( virtual/mpi ) )"
DEPEND="${RDEPEND}"

src_prepare(){
	default
	tc-export CC
	sed -e "s/gcc/$(tc-getCC)/g" \
		-e "s/g++/$(tc-getCXX)/g" \
		-e "s/-O3/${CFLAGS}/g" \
		-e 's/$(CC) -shared/$(CC) $(LDFLAGS) -shared/' \
		-e "s,/usr/local,${EPREFIX}/usr,g" \
		-e "s,/lib,/$(get_libdir),g" \
		-i makefile || die
}

src_compile () {
	if use gmp ; then
		emake
		emake all-shared
		use mpi && emake mplrs
	else
		emake allmp
	fi
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install-common
	if use gmp; then
		emake DESTDIR="${D}" install-shared prefix="${EPREFIX}/usr"
		use mpi && dobin mplrs
	fi
	dodoc README
}
