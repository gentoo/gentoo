# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="Flask-Compress"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Compress responses in your Flask app with gzip"
HOMEPAGE="
	https://github.com/colour-science/flask-compress/
	https://pypi.org/project/Flask-Compress/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"

# brotli on cpython, brotlicffi on pypy3
RDEPEND="
	app-arch/brotli[python,${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/zstandard[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask-caching[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
