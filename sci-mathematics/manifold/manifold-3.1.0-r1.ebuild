# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake python-single-r1

DESCRIPTION="Geometry library for topological robustness"
HOMEPAGE="https://github.com/elalish/manifold"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/elalish/manifold.git"
else
	if [[ ${PV} = *pre* ]] ; then
		COMMIT="e7e0780114881dcf6e5ad934323f2595966865f9"
		SRC_URI="https://github.com/elalish/manifold/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		SRC_URI="https://github.com/elalish/manifold/releases/download/v${PV}/${P}.tar.gz"
	fi

	KEYWORDS="amd64"
fi

LICENSE="Apache-2.0"
SLOT="0/1"

IUSE="debug python +tbb test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="
	tbb? ( dev-cpp/tbb:= )
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

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed \
		-e "/list(APPEND MANIFOLD_FLAGS/s/^/# DONOTSET /" \
		-i CMakeLists.txt || die

	sed \
		-e '/<memory>/a#include <cstdint>' \
		-i include/manifold/manifold.h || die
}

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CROSS_SECTION="yes"
		-DMANIFOLD_DEBUG="$(usex debug)"
		-DMANIFOLD_DOWNLOADS="no"
		-DMANIFOLD_EXPORT="no"
		-DMANIFOLD_JSBIND="no"
		-DMANIFOLD_PAR="$(usex tbb ON OFF)"
		-DMANIFOLD_PYBIND="$(usex python)"
		-DMANIFOLD_TEST="$(usex test)"
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}/test/manifold_test" || die
}
