# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="PEP 621 metadata parsing"
HOMEPAGE="
	https://github.com/FFY00/python-pyproject-metadata/
	https://pypi.org/project/pyproject-metadata/
"
SRC_URI="
	https://github.com/FFY00/python-pyproject-metadata/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
		' 3.{8..10})
	)
"

distutils_enable_tests pytest
