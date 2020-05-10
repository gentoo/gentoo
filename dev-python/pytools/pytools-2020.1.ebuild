# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="https://mathema.tician.de/software/pytools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/setuptools-0.7.2[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest
