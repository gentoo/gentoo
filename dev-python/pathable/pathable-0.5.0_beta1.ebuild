# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=${P/_beta/b}
DESCRIPTION="Object-oriented paths"
HOMEPAGE="
	https://pypi.org/project/pathable/
	https://github.com/p1c2u/pathable
"
SRC_URI="
	https://github.com/p1c2u/pathable/archive/${PV/_beta/b}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	=dev-python/pyrsistent-0.20*[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
