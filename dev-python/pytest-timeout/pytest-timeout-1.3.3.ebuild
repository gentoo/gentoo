# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to abort hanging tests"
HOMEPAGE="https://pypi.org/project/pytest-timeout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/pytest-timeout-1.3.3-tests.patch"
)

python_test() {
	distutils_install_for_testing

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
