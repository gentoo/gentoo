# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Get information about what a Python frame is currently doing"
HOMEPAGE="
	https://github.com/alexmojaki/executing/
	https://pypi.org/project/executing/"
SRC_URI="
	https://github.com/alexmojaki/executing/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86"

# asttokens is optional runtime dep
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/asttokens[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	# Kill off useless wheel dep
	sed -i -e 's/wheel; //' setup.cfg || die

	distutils-r1_src_prepare
}

python_test() {
	# this test explodes when collected by pytest
	"${EPYTHON}" tests/test_main.py || die "Tests failed with ${EPYTHON}"
	pytest -vv tests/test_pytest.py || die "Tests failed with ${EPYTHON}"
}
