# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="Flask-Sphinx-Themes"
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx Themes for Flask related projects and Flask itself"
HOMEPAGE="
	https://github.com/pallets/flask-sphinx-themes/
	https://pypi.org/project/Flask-Sphinx-Themes/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
