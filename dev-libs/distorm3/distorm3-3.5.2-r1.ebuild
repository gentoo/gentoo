# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/yasm )"

PATCHES=( "${FILESDIR}"/${P}-under.patch )

EPYTEST_DESELECT=(
	# outdated tests? API usage mismatch
	# https://github.com/gdabah/distorm/issues/173
	python/test_distorm3.py::Test::test_dummy
	python/test_distorm3.py::InstBin::test_dummy
	python/test_distorm3.py::Inst::test_dummy
)

distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install

	# don't know why it does not happen by default
	python_optimize
}
