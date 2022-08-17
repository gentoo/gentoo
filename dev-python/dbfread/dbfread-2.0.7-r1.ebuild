# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Read DBF Files with Python"
HOMEPAGE="https://github.com/olemb/dbfread https://pypi.org/project/dbfread/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( https://github.com/olemb/dbfread/archive/refs/tags/${PV}.tar.gz -> ${P}-src.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	dbfread/test_read_and_length.py::test_len
	dbfread/test_read_and_length.py::test_list
)

python_prepare_all() {
	sed -e 's|\[pytest\]|[tool:pytest]|' -i setup.cfg || die
	distutils-r1_python_prepare_all
}
