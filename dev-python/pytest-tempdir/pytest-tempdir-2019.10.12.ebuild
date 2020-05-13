# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Pytest plugin to support for a predictable and repeatable temporary directory"
HOMEPAGE="https://github.com/saltstack/pytest-tempdir"
SRC_URI="https://github.com/saltstack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
