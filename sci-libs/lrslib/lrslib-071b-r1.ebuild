# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Reverse-search algorithm for vertex enumeration problems"
HOMEPAGE="http://cgm.cs.mcgill.ca/~avis/C/lrs.html"
SRC_URI="http://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/${P}.tar.gz"

# COPYING is GPL-2, but e.g. lrslib.h says "or ... any later version."
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv"
IUSE="gmp mpi"

BDEPEND=""
RDEPEND="
	gmp? (
		dev-libs/gmp:0=
		mpi? ( virtual/mpi )
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-makefile-ldflags.patch"
	"${FILESDIR}/${P}-makefile-cflags.patch"
)

src_prepare() {
	default
	tc-export CC

	# The "makefile" sort-of supports CFLAGS as of lrslib-071b, but
	# "-O3" is still included verbatim in many targets. Likewise, a
	# LIBDIR variable exists but "lib" remains hard-coded in the install
	# targets.
	sed -e "s,/usr/local,${EPREFIX}/usr,g" \
		-e "s,/lib,/$(get_libdir),g" \
		-i makefile || die
}

src_compile() {
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
		emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
		use mpi && dobin mplrs
	fi
	dodoc README
}
