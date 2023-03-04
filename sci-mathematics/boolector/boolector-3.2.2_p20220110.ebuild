# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20220110 ]] && COMMIT=13a8a06d561041cafcaf5458e404c1ec354b2841

PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1 cmake

DESCRIPTION="Fast SMT solver for bit-vectors, arrays and uninterpreted functions"
HOMEPAGE="https://boolector.github.io/
	https://github.com/Boolector/boolector/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Boolector/${PN}.git"
else
	SRC_URI="https://github.com/Boolector/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="cryptominisat examples +gmp minisat +picosat python test"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	|| ( cryptominisat minisat picosat )
"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-mathematics/btor2tools:=
	cryptominisat? ( sci-mathematics/cryptominisat:= )
	gmp? ( dev-libs/gmp:= )
	minisat? ( sci-mathematics/minisat:= )
	picosat? ( sci-mathematics/picosat:= )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBtor2Tools_LIBRARIES=/usr/$(get_libdir)/libbtor2parser.so
		-DUSE_PYTHON2=OFF
		-DPYTHON=$(usex python)
		-DTESTING=$(usex test)
		-DUSE_GMP=$(usex gmp)
		-DUSE_PYTHON3=$(usex python)

		# Integration with other SMT solvers
		-DUSE_LINGELING=OFF  # Not packaged yet.
		-DUSE_CADICAL=OFF  # Fails to link.
		-DUSE_CMS=$(usex cryptominisat)
		-DUSE_MINISAT=$(usex minisat)
		-DUSE_PICOSAT=$(usex picosat)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodir /usr/$(get_libdir)
	mv "${ED}"/usr/lib/*.so "${ED}"/usr/$(get_libdir)/ || die

	if use examples ; then
		dodoc -r examples
	fi
}
