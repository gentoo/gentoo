# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Reverse-search algorithm for vertex enumeration problems"
HOMEPAGE="https://cgm.cs.mcgill.ca/~avis/C/lrs.html"
SRC_URI="https://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/${P}.tar.gz"

# COPYING is GPL-2, but e.g. lrslib.h says "or ... any later version."
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv"
IUSE="gmp mpi"

RDEPEND="
	gmp? (
		dev-libs/gmp:0=
		mpi? ( virtual/mpi )
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cflags-ldflags.patch"
)

src_prepare() {
	default
	tc-export CC

	# A LIBDIR variable exists in the makefile but "lib" remains
	# hard-coded in the install targets.
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

src_test() {
	bins=()

	if use gmp; then
		bins+=( "./lrs" )
		use mpi && bins+=( "mpirun ./mplrs" )
	fi

	for b in "${bins[@]}"; do
		for f in cube mp5; do
			# There are other ine/ext pairs in the tarball, but only
			# these two are at the top level and are obviously H/V
			# counterparts.

			echo "Testing example ${f} under ${b}..."
			# Convert this H-repr to a V-repr, keeping only the list of
			# vertices (which are indented by one space). We also sort
			# the output because it's only consistent up to a
			# permutation.
			${b} "${f}.ine" \
				| grep '^ ' \
				| sort \
				> "${T}/actual.txt" \
				|| die

			# The expected output is contained in the "ext" counterpart,
			# which we have to sort for the same reason we sorted the
			# actual output.
			grep '^ ' \
				"${f}.ext" \
				| sort \
				> "${T}/expected.txt" \
				|| die

			cmp "${T}/actual.txt" "${T}/expected.txt" \
				|| die "test case ${f} under ${b} failed"
		done
	done
}
