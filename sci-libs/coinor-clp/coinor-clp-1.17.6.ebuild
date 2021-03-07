# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=Clp

DESCRIPTION="COIN-OR linear programming solver"
HOMEPAGE="https://github.com/coin-or/Clp/"
SRC_URI="https://github.com/coin-or/${MY_PN}/archive/releases/${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="EPL-1.0"

# major soname component
SLOT="0/1"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk metis mumps sparse static-libs test"
RESTRICT="!test? ( test )"

# Fortran is NOT needed, but the ./configure scripts for all of the CoinOR
# packages contain a check for it. Gentoo bug 601648 and upstream issue,
#
#   https://github.com/coin-or/CoinUtils/issues/132
#
BDEPEND="virtual/fortran
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

# USE=mpi is disabled on sci-libs/mumps because mumps/scotch are in
# total disarray, but in particular for bugs 670759 and 695962. There
# used to be some conditional USE=mpi stuff in src_prepare() that will
# need to be put back if you restore the ability to build against
# mumps[mpi].
DEPEND="sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	glpk? ( sci-mathematics/glpk:= sci-libs/amd )
	metis? ( || ( sci-libs/metis sci-libs/parmetis ) )
	mumps? ( sci-libs/mumps[-mpi] )
	sparse? ( sci-libs/cholmod )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-releases-${PV}/${MY_PN}"

src_prepare() {
	# Needed to make the --with-coin-instdir in src_configure happy.
	dodir /usr

	# The file ClpCholeskyMumps.cpp does #include "mpi.h", and we
	# need to point it to the right file. Our sci-libs/mumps ebuild
	# is so ridiculous that I can't even tell if this is our fault
	# or if it's something that should be reported upstream.
	ln -s "${EPREFIX}"/usr/include/mpiseq/mpi.h src/mpi.h || die

	# They don't need to guess at this, but they do, and get it wrong...
	sed -e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
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
			--with-glpk-lib=-lglpk )
	else
		myeconfargs+=( --without-glpk )
	fi
	if use sparse; then
		myeconfargs+=(
			--with-amd-incdir="${EPREFIX}"/usr/include
			--with-amd-lib=-lamd
			--with-cholmod-incdir="${EPREFIX}"/usr/include
			--with-cholmod-lib=-lcholmod )
	else
		myeconfargs+=( --without-amd --without-cholmod )
	fi
	if use metis; then
		myeconfargs+=(
			--with-metis-incdir="$($(tc-getPKG_CONFIG) --cflags metis | sed s/-I//)"
			--with-metis-lib="$($(tc-getPKG_CONFIG) --libs metis)" )
	else
		myeconfargs+=( --without-metis )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-incdir="${EPREFIX}"/usr/include
			--with-mumps-lib="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps -lmpiseq" )
	else
		myeconfargs+=( --without-mumps )
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake all $(usex doc doxydoc "")
}

src_test() {
	# NOT redundant! The build system has a "make check" target that does
	# nothing, so if you don't specify "test" here, you'll get a no-op.
	emake test
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")

	emake DESTDIR="${D}" install

	# Duplicate junk, and in the wrong location.
	rm -r "${ED}/usr/share/coin/doc/${MY_PN}" || die

	use examples && dodoc -r examples
}
