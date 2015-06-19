# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ipopt/ipopt-3.11.7.ebuild,v 1.2 2014/02/04 08:33:36 jlec Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
FORTRAN_NEEDED="mumps"
inherit eutils autotools-utils multilib toolchain-funcs fortran-2

MYPN=Ipopt
MYP=${MYPN}-${PV}

DESCRIPTION="Interior-Point Optimizer for large-scale nonlinear optimization"
HOMEPAGE="https://projects.coin-or.org/Ipopt/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYP}.tgz"

LICENSE="EPL-1.0 hsl? ( HSL )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples hsl lapack mpi mumps static-libs test"

RDEPEND="
	virtual/blas
	hsl? ( sci-libs/coinhsl )
	lapack? ( virtual/lapack )
	mumps? ( sci-libs/mumps[mpi=] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample sci-libs/mumps )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	if use mumps && ! use mpi; then
		ln -s "${EPREFIX}"/usr/include/mpiseq/mpi.h \
			src/Algorithm/LinearSolvers/
	elif use mpi; then
		export CXX=mpicxx FC=mpif77 F77=mpif77 CC=mpicc
	fi
	sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	# needed for the --with-coin-instdir
	dodir /usr
	local myeconfargs=(
		--enable-dependency-linking
		--with-blas-lib="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-coin-instdir="${ED}"/usr
		$(use_with doc dot)
	)

	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-incdir="${EPREFIX}"/usr/include
			--with-mumps-lib="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps" )
	else
		myeconfargs+=( --without-mumps )
	fi
	if use hsl; then
		myeconfargs+=(
			--with-hsl-incdir="${EPREFIX}"/usr/include
			--with-hsl-lib="$($(tc-getPKG_CONFIG) --libs coinhsl)" )
	else
		myeconfargs+=( --without-hsl )
	fi
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(use doc && echo doxydoc)
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	use doc && HTML_DOC=("${AUTOTOOLS_BUILD_DIR}/doxydocs/html/")
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
