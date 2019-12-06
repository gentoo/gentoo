# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage virtual environments"
HOMEPAGE="https://github.com/dephell/dephell_venvs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/dephell_pythons[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='${PN}',version='${PV}',%s)" \
		"packages=find_packages(exclude=['tests'])" \
		> setup.py

	distutils-r1_python_prepare_all
}

python_test() {
	if [[ ${EPYTHON} == pypy* ]]; then
		ewarn "Skipping tests on ${EPYTHON} since they are broken on pypy"
		return 0
	fi

	cp -r "${S}/tests" "${BUILD_DIR}/tests" || die

	pushd "${BUILD_DIR}" >/dev/null || die
	pytest -vv tests/ || die "Tests fail with ${EPYTHON}"
	popd >/dev/null || die
}
