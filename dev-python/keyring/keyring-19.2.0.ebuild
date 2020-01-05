# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://github.com/jaraco/keyring"
SRC_URI="https://github.com/jaraco/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/secretstorage[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/keyring-19.1.0-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/jaraco-packaging dev-python/rst-linker

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i "s:setuptools(_|-)scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+|)[[:space:]]*::" \
		setup.cfg || die

	# avoid other deps
	sed -i -r "$(printf -- 's:[[:space:]]*--%s::;' --doctest-modules --flake8 --black --cov)" \
		pytest.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Override pytest options to skip flake8
	# Skip an interactive test
	pytest -vv --override-ini="addopts=--doctest-modules" \
		--ignore ${PN}/tests/backends/test_kwallet.py \
		|| die "testsuite failed under ${EPYTHON}"
}
