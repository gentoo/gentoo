# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a backport of Python 3.9's importlib.resources
PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://github.com/python/importlib_resources"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/zipp[${PYTHON_USEDEP}]
	' pypy3 python3_{6,7})
"
BDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
distutils_enable_sphinx docs dev-python/rst-linker dev-python/jaraco-packaging
