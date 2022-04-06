# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A high-performance immutable mapping type for Python"
HOMEPAGE="https://github.com/MagicStack/immutables"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/mypy/d' tests/conftest.py || die
	distutils-r1_src_prepare
}

python_test() {
	# force running from BUILD_DIR to get the C extension tested
	cp -r tests "${BUILD_DIR}"/lib || die
	cd "${BUILD_DIR}"/lib || die
	epytest tests --ignore tests/test_mypy.py
	rm -r tests || die
}
