# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=66bca6e3fdfce0f590ca84edc1a6256502636f4b
PYTHON_COMPAT=( python3_{10..13} )
inherit cmake python-single-r1

DESCRIPTION="Geometry library for topological robustness"
HOMEPAGE="https://github.com/elalish/manifold"
SRC_URI="https://github.com/elalish/manifold/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test ) mirror"

RDEPEND="
	dev-cpp/tbb
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
	${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CROSS_SECTION=ON
		-DMANIFOLD_DEBUG=$(usex debug)
		-DMANIFOLD_DOWNLOADS=OFF
		-DMANIFOLD_EXPORT=OFF
		-DMANIFOLD_JSBIND=OFF
		-DMANIFOLD_PAR=ON
		-DMANIFOLD_PYBIND=$(usex python)
		-DMANIFOLD_TEST=$(usex test)
	)
	if use debug; then
		mycmakeargs+=(
			-DMANIFOLD_FLAGS=-ggdb
		)
	fi
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/test/manifold_test || die
}
