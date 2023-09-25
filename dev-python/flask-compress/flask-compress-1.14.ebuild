# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="Flask-Compress"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Compress responses in your Flask app with gzip"
HOMEPAGE="
	https://github.com/colour-science/flask-compress/
	https://pypi.org/project/Flask-Compress/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# brotli on cpython, brotlicffi on pypy3
RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
