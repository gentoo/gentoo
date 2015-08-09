# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
EGIT_REPO_URI="https://github.com/Diaoul/enzyme.git"

inherit distutils-r1 git-2

DESCRIPTION="Python video metadata parser"
HOMEPAGE="https://github.com/Diaoul/enzyme https://pypi.python.org/pypi/enzyme"
SRC_URI="test? ( http://downloads.sourceforge.net/project/matroska/test_files/matroska_test_w1_1.zip )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
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
