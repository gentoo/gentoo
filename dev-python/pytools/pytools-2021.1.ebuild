# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='sqlite'
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="https://mathema.tician.de/software/pytools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
