# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/fonttools/fonttools/"
SRC_URI="https://github.com/fonttools/fonttools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]

		>=dev-python/fs-2.4.9[${PYTHON_USEDEP}]
		app-arch/brotli[python,${PYTHON_USEDEP}]
		app-arch/zopfli
		python_targets_python2_7? (
			dev-python/backports-os[python_targets_python2_7]
		)
	)"

python_prepare_all() {
	# When dev-python/pytest-shutil is installed, we get weird import errors.
	# This is due to incomplete nesting in the Tests/ tree:
	#
	#   Tests/feaLib/__init__.py
	#   Tests/ufoLib/__init__.py
	#   Tests/svgLib/path/__init__.py
	#   Tests/otlLib/__init__.py
	#   Tests/varLib/__init__.py
	#
	# This tree requires an __init__.py in Tests/svgLib/ too, bug #701148.
	touch Tests/svgLib/__init__.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# virtualx used when matplotlib is installed causing plot module tests to run
	virtx pytest -vv Tests fontTools
}
