# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1

DESCRIPTION="Python video metadata parser"
HOMEPAGE="https://github.com/Diaoul/enzyme https://pypi.python.org/pypi/enzyme"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( mirror://sourceforge/matroska/test_files/matroska_test_w1_1.zip )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		app-arch/unzip
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	if use test; then
		mkdir enzyme/tests/test_{parsers,mkv} || die
		ln -s "${WORKDIR}"/test* enzyme/tests/test_parsers/ || die
		ln -s "${WORKDIR}"/test* enzyme/tests/test_mkv/ || die
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
