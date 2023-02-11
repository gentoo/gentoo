# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="
	https://github.com/jaraco/rst.linker/
	https://pypi.org/project/rst.linker/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN/-/.}")"
S=${WORKDIR}/${P/-/.}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-3.4.1[${PYTHON_USEDEP}]
	test? (
		dev-python/path[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
