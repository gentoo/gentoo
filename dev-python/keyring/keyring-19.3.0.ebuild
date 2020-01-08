# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://github.com/jaraco/keyring"
SRC_URI="https://github.com/jaraco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/secretstorage[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' pypy3 python3_{5,6,7})
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/keyring-19.1.0-tests.patch"
	# https://github.com/jaraco/keyring/commit/411204df606bdf02c99f3360ec033e3c235d5f67
	"${FILESDIR}/keyring-19.3.0-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/jaraco-packaging \
	dev-python/rst-linker

python_prepare_all() {
	# avoid setuptools_scm and a bunch of style checker dependencies
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r \
		-e "s:setuptools(_|-)scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+|)[[:space:]]*::" \
		-e "/pytest-checkdocs/ d" \
		-e "/pytest-flake8/ d" \
		-e "/pytest-black-multipy/ d" \
		-e "/pytest-cov/ d" \
		-i setup.cfg || die

	# avoid other deps
	local -a pytest_params=(doctest-modules flake8 black cov)
	sed -r -e "$(printf -- 's:[[:space:]]*--%s:: ;' "${pytest_params[@]}")" \
		-i pytest.ini || die

	rm ${PN}/tests/backends/test_kwallet.py || die

	distutils-r1_python_prepare_all
}
