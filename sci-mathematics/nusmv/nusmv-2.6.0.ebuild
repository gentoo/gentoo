# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-any-r1 toolchain-funcs

MY_P="NuSMV-${PV}"
NUSMV_A="${MY_P}.tar.gz"
ZCHAFF_A="zchaff.64bit.2007.3.12.zip"

DESCRIPTION="NuSMV: new symbolic model checker"
HOMEPAGE="http://nusmv.fbk.eu/"
SRC_URI="http://nusmv.fbk.eu/distrib/${NUSMV_A}
		zchaff? ( http://www.princeton.edu/~chaff/zchaff/${ZCHAFF_A} )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minisat doc zchaff"
REQUIRED_USE="|| ( minisat zchaff )"

SHARED_DEPEND="minisat? ( >=sci-mathematics/minisat-2.2.0_p20130925 )"
RDEPEND="${SHARED_DEPEND}
	dev-libs/expat"
DEPEND="${SHARED_DEPEND}
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		app-doc/doxygen
	)
	dev-libs/libxml2
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}/NuSMV"

src_unpack() {
	unpack "${NUSMV_A}"
	if use zchaff; then
		cp "${DISTDIR}/${ZCHAFF_A}" "${WORKDIR}/${MY_P}/zChaff" || die
	fi
}

src_prepare() {
	sed -i -e 's/-mcpu=[^\s]*//' "${WORKDIR}/${MY_P}/cudd-2.4.1.1"/Makefile || die
	# Prevent automatic build of minisat - we are using the ebuild from portage
	sed -i -e 's/    add_subdirectory(${MINISAT_SOURCE_DIR} ${MINISAT_BUILD_DIR})//' \
		-e 's/MINISAT_LIB/MiniSat/' CMakeLists.txt || die
	sed -i -e 's/DEPENDS MINISAT_BUILD//' code/nusmv/core/sat/solvers/CMakeLists.txt || die
	# Change the "prog-man/html" rule to optional
	sed -i -e '/\s*install( .*html /s:${PROJECT_BINARY_DIR}:share/nusmv/doc OPTIONAL:' doc/prog-man/CMakeLists.txt || die
	# Change the doc destination
	sed -i -e "s:share/nusmv/doc:share/doc/${PF}:" doc/{tutorial,user-man,prog-man}/CMakeLists.txt || die

	# Correction for proper parallel compilation
#	sed -i -e 's/COMMAND ${MAKE}/COMMAND $(MAKE)/' "${WORKDIR}/${MY_P}/"{zchaff,MiniSat}/CMakeLists.txt || die
	default
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_MINISAT=$(usex minisat)
		-DENABLE_ZCHAFF=$(usex zchaff)
		-DMINISAT_INCLUDE_DIR="${EPREFIX}"/usr/include/minisat/simp
	)

	cmake-utils_src_configure
}

src_compile() {
	local targets=( all )
	use doc && targets+=( prog-man user-man html tutorial docs )
	cmake-utils_src_compile "${targets[@]}"
}

src_install() {
	cmake-utils_src_install
	# Remove docs where they do not belong to
	rm -f "${ED%/}"/usr/share/nusmv/{LGPL-2.1,README*,NEWS} || die
}
