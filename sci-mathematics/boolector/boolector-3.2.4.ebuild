# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1 cmake

DESCRIPTION="Fast SMT solver for bit-vectors, arrays and uninterpreted functions"
HOMEPAGE="https://boolector.github.io/
	https://github.com/Boolector/boolector/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Boolector/${PN}.git"
else
	SRC_URI="https://github.com/Boolector/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

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
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/boolector-3.2.3-cmake-std.patch"
	"${FILESDIR}/boolector-3.2.4-cmake_minimum_required.patch"
)

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

	if use examples ; then
		dodoc -r examples
	fi

	if [[ "$(get_libdir)" != lib ]] ; then
		dodir "/usr/$(get_libdir)"
		mv "${ED}/usr/lib"/*.so "${ED}/usr/$(get_libdir)/" || die
	fi
}
