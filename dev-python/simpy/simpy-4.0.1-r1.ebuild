# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="tk"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_P="${P/simpy/SimPy}"

DESCRIPTION="Object-oriented, process-based discrete-event simulation language"
HOMEPAGE="https://simpy.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

# Could not import extension sphinx.builders.epub3 (exception: cannot import
# name 'StandaloneHTMLBuilder' from partially initialized module
# 'sphinx.builders.html' (most likely due to a circular import)
# (/usr/lib/python3.10/site-packages/sphinx/builders/html/__init__.py))
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
