# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=e7e0780114881dcf6e5ad934323f2595966865f9
PYTHON_COMPAT=( python3_{10..13} )
inherit cmake python-single-r1

DESCRIPTION="Geometry library for topological robustness"
HOMEPAGE="https://github.com/elalish/manifold"
SRC_URI="https://github.com/elalish/manifold/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

IUSE="debug python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/tbb:=
	sci-mathematics/clipper2
	python? ( ${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/nanobind-2.1.0[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-cpp/gtest )
	${RDEPEND}
"

src_prepare() {
	cmake_src_prepare

	sed \
		-e "/list(APPEND MANIFOLD_FLAGS/s/^/# DONOTSET /" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CROSS_SECTION="yes"
		-DMANIFOLD_DEBUG="$(usex debug)"
		-DMANIFOLD_DOWNLOADS="no"
		-DMANIFOLD_EXPORT="no"
		-DMANIFOLD_JSBIND="no"
		-DMANIFOLD_PAR="no"
		-DMANIFOLD_PYBIND="$(usex python)"
		-DMANIFOLD_TEST="$(usex test)"
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}/test/manifold_test" || die
}
