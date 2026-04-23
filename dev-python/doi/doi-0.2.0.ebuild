# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="python-doi"
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python package to work with Document Object Identifier (doi)."
HOMEPAGE="
	https://pypi.org/project/python-doi
	https://github.com/papis/python-doi
"
S="${WORKDIR}/${PYPI_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
    # require network access
    tests/test_doi.py::test_get_real_url_from_doi
    tests/test_doi.py::test_validate_doi
)
