# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Python interface to last.fm and other api-compatible websites"
HOMEPAGE="https://github.com/pylast/pylast"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? ( dev-python/flaky[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove setuptools-scm dependency
	sed -e 's:"setuptools_scm"::' \
		-e "s:use_scm_version=.*:version='${PV}',:" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "tests failed with ${EPYTHON}"
}
