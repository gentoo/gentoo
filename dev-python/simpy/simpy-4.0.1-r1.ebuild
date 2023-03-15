# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="tk"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Object-oriented, process-based discrete-event simulation language"
HOMEPAGE="https://simpy.readthedocs.io/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

# Could not import extension sphinx.builders.epub3 (exception: cannot import
# name 'StandaloneHTMLBuilder' from partially initialized module
# 'sphinx.builders.html' (most likely due to a circular import)
# (/usr/lib/python3.10/site-packages/sphinx/builders/html/__init__.py))
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
