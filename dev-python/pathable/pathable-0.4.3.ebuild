# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Object-oriented paths"
HOMEPAGE="
	https://pypi.org/project/pathable/
	https://github.com/p1c2u/pathable
"
SRC_URI="
	https://github.com/p1c2u/pathable/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/--cov/d' -i pyproject.toml || die
	distutils-r1_src_prepare
}
