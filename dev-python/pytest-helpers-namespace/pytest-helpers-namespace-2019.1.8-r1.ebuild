# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Provides a helpers pytest namespace"
HOMEPAGE="https://github.com/saltstack/pytest-helpers-namespace"
SRC_URI="https://github.com/saltstack/${PN}/archive/v${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-forked[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -e 's:(foo|bar):namespace_\1:g' \
		-i tests/test_helpers_namespace.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest --forked -vv || die "Tests failed with ${EPYTHON}"
}
