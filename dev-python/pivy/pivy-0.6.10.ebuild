# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Coin3D bindings for Python"
HOMEPAGE="https://github.com/coin3d/pivy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	PIVY_REPO_URI="https://github.com/coin3d/pivy.git"
else
	SRC_URI="
		https://github.com/coin3d/pivy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="amd64 x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="+quarter soqt test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( quarter soqt )
"

RDEPEND="
	>=media-libs/coin-4.0.0
	quarter? ( media-libs/quarter )
	soqt? ( >=media-libs/SoQt-1.6.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/cmake
	dev-lang/swig
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.6-0001-fix-CMakeLists.txt-for-distutils_cmake.patch
	"${FILESDIR}"/${PN}-0.6.6-0002-Gentoo-specific-clear-swig-deprecation-warning.patch
	"${FILESDIR}"/${PN}-0.6.7-find-qmake.patch
	# in 0.6.9:
	"${FILESDIR}"/${PN}-0.6.8-SoQtViewer-w-cmath.patch # bug 920482
)

DOCS=( AUTHORS HACKING NEWS README.md THANKS )

python_test() {
	# visual_test.py is interactive
	tests=(
		tests/coin_tests.py
		tests/pyside_tests.py
		tests/quarter_tests.py
	)
	for f in "${strings[@]}"; do
		"${EPYTHON}" "${f}" || die "Test ${f} failed with ${EPYTHON}"
	done
}
