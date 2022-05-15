# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A high-performance immutable mapping type for Python"
HOMEPAGE="
	https://github.com/MagicStack/immutables/
	https://pypi.org/project/immutables/
"
SRC_URI="
	https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc ~x86"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/mypy/d' tests/conftest.py || die
	distutils-r1_src_prepare
}

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests --ignore "${S}"/tests/test_mypy.py
}
