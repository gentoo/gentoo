# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{11..14} )

DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Pure Python read/write support for ESRI Shapefile format"
HOMEPAGE="https://pypi.org/project/pyshp/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest test_shapefile.py -m "not network"
}
