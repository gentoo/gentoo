# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
CLI_COMPAT=( python3_{8..10} )
PYTHON_COMPAT=( "${CLI_COMPAT[@]}" python3_11 pypy3 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 multiprocessing optfeature

TAG=hypothesis-python-${PV}
MY_P=hypothesis-${TAG}
DESCRIPTION="A library for property based testing"
HOMEPAGE="
	https://github.com/HypothesisWorks/hypothesis/
	https://pypi.org/project/hypothesis/
"
SRC_URI="
	https://github.com/HypothesisWorks/hypothesis/archive/${TAG}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}/hypothesis-python"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="cli"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/exceptiongroup-1.0.0_rc8[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
	cli? (
		$(python_gen_cond_dep '
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
		' "${CLI_COMPAT[@]}")
	)
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# subtests are broken by warnings from random plugins
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=xdist.plugin,pytest_forked,_hypothesis_pytestplugin

	epytest tests/cover tests/pytest tests/quality -n "$(makeopts_jobs)"
}

python_install() {
	distutils-r1_python_install
	if ! use cli || ! has "${EPYTHON}" "${CLI_COMPAT[@]/_/.}"; then
		rm -r "${ED}/usr/bin" "${D}$(python_get_scriptdir)" || die
	fi
}

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pandas support" dev-python/pandas
	optfeature "pytest support" dev-python/pytest
}
