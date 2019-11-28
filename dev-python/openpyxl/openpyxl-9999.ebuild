# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1 mercurial

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="https://openpyxl.readthedocs.io/en/stable/"
EHG_REPO_URI="https://bitbucket.org/openpyxl/openpyxl"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/et_xmlfile[${PYTHON_USEDEP}]
	dev-python/jdcal[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff,jpeg]
	)"

distutils_enable_tests pytest
distutils_enable_sphinx doc
