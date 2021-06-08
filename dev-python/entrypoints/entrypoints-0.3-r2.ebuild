# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( pypy3 python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Discover and load entry points from installed packages"
HOMEPAGE="https://github.com/takluyver/entrypoints"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}"-0.2.1-init.py.patch
)

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
