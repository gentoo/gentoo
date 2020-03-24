# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Hunter is a flexible code tracing toolkit"
HOMEPAGE="
	https://github.com/ionelmc/python-hunter
	https://pypi.org/project/hunter
"
SRC_URI="https://github.com/ionelmc/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/aspectlib[${PYTHON_USEDEP}]
		dev-python/manhole[${PYTHON_USEDEP}]
		dev-python/process-tests[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-travis-fold[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-3.3.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs ">=dev-python/sphinx-py3doc-enhanced-theme-2.3.2"
