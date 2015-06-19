# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-clp/coinor-clp-1.15.6-r1.ebuild,v 1.6 2014/02/04 10:33:16 jlec Exp $

EAPI=5

inherit autotools-utils eutils multilib toolchain-funcs

MYPN=Clp

DESCRIPTION="COIN-OR Linear Programming solver"
HOMEPAGE="https://projects.coin-or.org/Clp/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk metis mumps sparse static-libs test"

RDEPEND="
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	glpk? ( sci-mathematics/glpk:= sci-libs/amd )
	metis? ( || ( sci-libs/metis sci-libs/parmetis ) )
	mumps? ( sci-libs/mumps )
	sparse? ( sci-libs/cholmod )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.15.6-mpi-header.patch
	"${FILESDIR}"/${PN}-1.15.6-overflow.patch
)

src_prepare() {
	# needed for the --with-coin-instdir
	dodir /usr
	if has_version sci-libs/mumps[-mpi]; then
		ln -s "${EPREFIX}"/usr/include/mpiseq/mpi.h src/mpi.h
	elif has_version sci-libs/mumps[mpi]; then
		export CXX=mpicxx
	fi
	sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-aboca
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
			--with-mumps-lib="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps" )
	else
		myeconfargs+=( --without-mumps )
	fi
	autotools-utils_src_configure
}

src_compile() {
	# hack for parallel build, to overcome not patching Makefile.am above
	#autotools-utils_src_compile -C src libClp.la
	autotools-utils_src_compile all $(usex doc doxydoc "")
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	use doc && HTML_DOC=("${BUILD_DIR}/doxydocs/html/")
	# hack for parallel install, to overcome not patching Makefile.am above
	#autotools-utils_src_install -C src install-am
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
