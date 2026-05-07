# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN="WTForms"
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="
	https://wtforms.readthedocs.io/
	https://github.com/pallets-eco/wtforms/
	https://pypi.org/project/WTForms/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/markupsafe-1.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/babel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/email-validator-2.0[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
