# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1

DESCRIPTION="Python video metadata parser"
HOMEPAGE="https://github.com/Diaoul/enzyme https://pypi.org/project/enzyme/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( mirror://sourceforge/matroska/test_files/matroska_test_w1_1.zip )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/unzip
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

python_prepare_all() {
	if use test; then
		mkdir enzyme/tests/test_{mkv,parsers} || die
		ln -s "${WORKDIR}"/test*.mkv enzyme/tests/test_mkv/ || die
		ln -s "${WORKDIR}"/test*.mkv enzyme/tests/test_parsers/ || die
	fi

	distutils-r1_python_prepare_all
}
