# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="https://openpyxl.readthedocs.io/en/stable/"
# Upstream doesn't want to include tests in PyPI tarballs
SRC_URI="https://foss.heptapod.net/openpyxl/openpyxl/-/archive/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 x86"

RDEPEND="
	dev-python/et_xmlfile[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff,jpeg]
	)"

distutils_enable_sphinx doc
distutils_enable_tests pytest
