# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Coin3D bindings for Python"
HOMEPAGE="https://github.com/coin3d/pivy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	PIVY_REPO_URI="https://github.com/coin3d/pivy.git"
else
	SRC_URI="https://github.com/coin3d/pivy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
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
	dev-lang/swig
	dev-util/cmake
	test? ( ${RDEPEND} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.6-0001-fix-CMakeLists.txt-for-distutils_cmake.patch
	"${FILESDIR}"/${PN}-0.6.6-0002-Gentoo-specific-clear-swig-deprecation-warning.patch
	"${FILESDIR}"/${PN}-0.6.7-find-qmake.patch
)

DOCS=( AUTHORS HACKING NEWS README.md THANKS )

python_test() {
	# visual_test.py is interactive
	# pyside_test.py currently fails
	# quarter_tests.py needs pyside2, which currently lacks py3_11 support
	for f in tests/coin_tests.py; do
		"${EPYTHON}" "${f}" || die "Test ${f} failed with ${EPYTHON}"
	done
}
