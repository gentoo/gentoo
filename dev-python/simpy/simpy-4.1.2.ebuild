# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} )
PYTHON_REQ_USE="tk"

inherit distutils-r1 pypi

DESCRIPTION="Object-oriented, process-based discrete-event simulation language"
HOMEPAGE="
	https://simpy.readthedocs.io/
	https://gitlab.com/team-simpy/simpy/
	https://pypi.org/project/simpy/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/py[${PYTHON_USEDEP}]
	)
"

# Could not import extension sphinx.builders.epub3 (exception: cannot import
# name 'StandaloneHTMLBuilder' from partially initialized module
# 'sphinx.builders.html' (most likely due to a circular import)
# (/usr/lib/python3.10/site-packages/sphinx/builders/html/__init__.py))
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
EPYTEST_PLUGINS=()
distutils_enable_tests pytest
