# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A tiny LRU cache implementation and decorator"
HOMEPAGE="
	https://github.com/repoze/repoze.lru/
	https://pypi.org/project/repoze.lru/
"
SRC_URI="
	https://github.com/repoze/repoze.lru/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ~ppc64 ~riscv x86"

RDEPEND="
	!dev-python/namespace-repoze
"

distutils_enable_tests unittest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
