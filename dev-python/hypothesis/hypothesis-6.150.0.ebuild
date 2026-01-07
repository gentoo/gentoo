# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
CLI_COMPAT=( python3_{11..13} )
PYTHON_COMPAT=( "${CLI_COMPAT[@]}" pypy3_11 python3_14 python3_{13,14}t )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 optfeature

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cli"

RDEPEND="
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	cli? (
		$(python_gen_cond_dep '
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
		' "${CLI_COMPAT[@]}")
	)
"
BDEPEND="
	test? (
		>=dev-python/attrs-22.2.0[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	dev-python/hypothesis-gentoo[${PYTHON_USEDEP}]
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-xdist )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	# NB: paths need to be relative to pytest.ini,
	# i.e. start with hypothesis-python/

	local -x HYPOTHESIS_NO_PLUGINS=1
	epytest -o filterwarnings= tests/{cover,pytest,quality}
}

src_install() {
	local HAD_CLI=

	distutils-r1_src_install

	if [[ ! ${HAD_CLI} ]]; then
		rm -r "${ED}/usr/bin" || die
	fi
}

python_install() {
	distutils-r1_python_install
	if use cli && has "${EPYTHON}" "${CLI_COMPAT[@]/_/.}"; then
		HAD_CLI=1
	else
		rm -r "${D}$(python_get_scriptdir)" || die
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
