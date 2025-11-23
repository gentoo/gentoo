# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..13} pypy3_11 )
inherit distutils-r1 pypi

DESCRIPTION="A set of pytest fixtures to test Flask applications"
HOMEPAGE="
	https://pytest-flask.readthedocs.io/
	https://github.com/pytest-dev/pytest-flask/
	https://pypi.org/project/pytest-flask/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest
