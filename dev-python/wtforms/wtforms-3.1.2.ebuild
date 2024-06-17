# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN="WTForms"
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="
	https://wtforms.readthedocs.io/
	https://github.com/wtforms/wtforms/
	https://pypi.org/project/WTForms/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		dev-python/email-validator[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
