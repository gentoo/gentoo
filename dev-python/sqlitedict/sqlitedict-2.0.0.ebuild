# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Persistent dict in Python, backed by SQLite and pickle"
HOMEPAGE="
	https://github.com/RaRe-Technologies/sqlitedict/
	https://pypi.org/project/sqlitedict/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"

DOCS=( README.rst )

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_core.py::TablenamesTest::test_tablenames
	tests/test_onimport.py::SqliteDictPython24Test::test_py24_error
)
