# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Easily displaying tabular data in a visually appealing ASCII table format"
HOMEPAGE="
	https://github.com/jazzband/prettytable/
	https://pypi.org/project/prettytable/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/pytest-lazy-fixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
