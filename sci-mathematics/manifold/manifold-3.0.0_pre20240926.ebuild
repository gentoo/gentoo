# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=a24cca1f0621b9245ff15540934d654112191c62
PYTHON_COMPAT=( python3_{10..12} )
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
	media-libs/glm
	python? (
		$(python_gen_cond_dep '
			dev-python/nanobind[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-cpp/gtest )
	${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CBIND=OFF
		-DMANIFOLD_CROSS_SECTION=ON
		-DMANIFOLD_DEBUG=$(usex debug)
		-DMANIFOLD_EXPORT=OFF
		-DMANIFOLD_JSBIND=OFF
		-DMANIFOLD_PAR=TBB
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
