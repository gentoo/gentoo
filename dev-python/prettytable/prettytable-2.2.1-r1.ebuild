# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Easily displaying tabular data in a visually appealing ASCII table format"
HOMEPAGE="
	https://github.com/jazzband/prettytable/
	https://pypi.org/project/prettytable/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
	)"

distutils_enable_tests --install pytest
