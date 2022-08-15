# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="
	https://mathema.tician.de/software/pytools/
	https://github.com/inducer/pytools/
	https://pypi.org/project/pytools/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

# NB: numpy is now an "extra" (optional) dep -- we can remove it from
# RDEPEND If revdeps don't need it
RDEPEND="
	>=dev-python/numpy-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
"

distutils_enable_tests pytest
