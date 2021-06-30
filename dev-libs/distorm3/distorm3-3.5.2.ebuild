# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND=""
BDEPEND="test? ( dev-lang/yasm )"

distutils_enable_tests pytest

PATCHES=("${FILESDIR}"/${P}-under.patch)

python_install() {
	distutils-r1_python_install

	# don't know why it does not happen by default
	python_optimize
}

python_test() {
	local exclude=(
		# outdated tests? API udage mismatch
		# https://github.com/gdabah/distorm/issues/173
		python/test_distorm3.py::Test::test_dummy
		python/test_distorm3.py::InstBin::test_dummy
		python/test_distorm3.py::Inst::test_dummy
	)
	epytest ${exclude[@]/#/--deselect }
}
