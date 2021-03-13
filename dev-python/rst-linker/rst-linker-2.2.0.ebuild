# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="https://github.com/jaraco/rst.linker"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' pypy3 python3_{6,7})
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/path-py[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs ">=dev-python/jaraco-packaging-3.2"
distutils_enable_tests pytest
