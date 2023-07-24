# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN="Flask-SQLAlchemy"
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="SQLAlchemy support for Flask applications"
HOMEPAGE="
	https://github.com/pallets-eco/flask-sqlalchemy/
	https://pypi.org/project/Flask-SQLAlchemy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/flask-2.2.5[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.18[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/blinker[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues \
	dev-python/sphinxcontrib-log-cabinet
