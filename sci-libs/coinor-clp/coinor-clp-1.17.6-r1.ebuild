# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
DOCS_DIR="doxydoc"
DOCS_CONFIG_NAME="doxygen.conf"
inherit docs toolchain-funcs

MY_PN=Clp

DESCRIPTION="COIN-OR linear programming solver"
HOMEPAGE="https://github.com/coin-or/Clp"
SRC_URI="https://github.com/coin-or/Clp/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-releases-${PV}/${MY_PN}"

LICENSE="EPL-1.0"
SLOT="0/1" # major soname component
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples glpk metis mpi mumps sparse static-libs test"
REQUIRED_USE="mpi? ( mumps )"
RESTRICT="!test? ( test )"

# Fortran is NOT needed, but the ./configure scripts for all of the CoinOR
# packages contain a check for it. Gentoo bug 601648 and upstream issue,
#
#   https://github.com/coin-or/CoinUtils/issues/132
#
BDEPEND="
	virtual/fortran
	virtual/pkgconfig
	test? ( sci-libs/coinor-sample )
"
DEPEND="
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	glpk? ( sci-mathematics/glpk:= sci-libs/amd )
	metis? ( sci-libs/metis )
	mumps? ( sci-libs/mumps[mpi?] )
	sparse? ( sci-libs/cholmod )
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Needed to make the --with-coin-instdir in src_configure happy.
	dodir /usr

	mumpslibs="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps"

	if use mumps; then
		if use mpi; then
			# https://github.com/coin-or/Clp/issues/199
			eapply "${FILESDIR}/${P}-remove-extern-C-for-MPI.patch"
			export CXX=mpicxx
		else
			# The file ClpCholeskyMumps.cpp does #include "mpi.h", and we
			# need to point it to the right file. Our sci-libs/mumps ebuild
			# is so ridiculous that I can't even tell if this is our fault
			# or if it's something that should be reported upstream.
			ln -s "${EPREFIX}/usr/include/mpiseq/mpi.h" src/mpi.h || die
			mumpslibs="${mumpslibs} -lmpiseq"
		fi
	fi

	# They don't need to guess at this, but they do, and get it wrong...
	sed -e "s|lib/pkgconfig|$(get_libdir)/pkgconfig|g" \
		-i configure \
		|| die "failed to fix the pkgconfig path in ${S}/configure"

	default
}

src_configure() {
	# The --enable-aboca flag is temporarily disabled, because the build
	# is broken with it (see https://github.com/coin-or/Clp/issues/139).
	# There's a fix, but I'm not going to bother with a patch for an
	# an experimental feature.
	local myeconfargs=(
		--enable-dependency-linking
		--with-coin-instdir="${ED}"/usr
		$(use_with doc dot)
	)
	if use glpk; then
		myeconfargs+=(
			--with-amd-incdir="${EPREFIX}"/usr/include
			--with-amd-lib=-lamd
			--with-glpk-incdir="${EPREFIX}"/usr/include
			--with-glpk-lib=-lglpk
		)
	else
		myeconfargs+=( --without-glpk )
	fi
	if use sparse; then
		myeconfargs+=(
			--with-amd-incdir="${EPREFIX}"/usr/include
			--with-amd-lib=-lamd
			--with-cholmod-incdir="${EPREFIX}"/usr/include
			--with-cholmod-lib=-lcholmod
		)
	else
		myeconfargs+=( --without-amd --without-cholmod )
	fi
	if use metis; then
		myeconfargs+=(
			--with-metis-incdir="$($(tc-getPKG_CONFIG) --cflags metis | sed s/-I//)"
			--with-metis-lib="$($(tc-getPKG_CONFIG) --libs metis)"
		)
	else
		myeconfargs+=( --without-metis )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-incdir="${EPREFIX}"/usr/include
			--with-mumps-lib="$mumpslibs"
		)
	else
		myeconfargs+=( --without-mumps )
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake all
	docs_compile
}

src_test() {
	# NOT redundant! The build system has a "make check" target that does
	# nothing, so if you don't specify "test" here, you'll get a no-op.
	emake test
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	# Duplicate junk, and in the wrong location.
	rm -r "${ED}/usr/share/coin/doc/${MY_PN}" || die

	use examples && dodoc -r examples

	find "${ED}" -name '*.la' -delete || die
}
