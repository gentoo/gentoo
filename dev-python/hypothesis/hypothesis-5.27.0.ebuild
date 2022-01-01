# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 optfeature

DESCRIPTION="A library for property based testing"
HOMEPAGE="https://github.com/HypothesisWorks/hypothesis https://pypi.org/project/hypothesis/"
SRC_URI="https://github.com/HypothesisWorks/${PN}/archive/${PN}-python-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-python-${PV}/${PN}-python"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~x86"
IUSE="cli test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	cli? (
		$(python_gen_cond_dep '
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
		' python3_{6..8})
	)
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.3.5[${PYTHON_USEDEP}]
		!!<dev-python/typing-3.7.4.1
	)
"

src_prepare() {
	# avoid pytest-xdist dep for one test
	sed -i -e 's:test_prints_statistics_given_option_under_xdist:_&:' \
		tests/pytest/test_statistics.py || die
	distutils-r1_src_prepare
}

python_prepare() {
	if ! use cli || [[ ${EPYTHON} != python3.[678] ]]; then
		sed -i -e '/console_scripts/d' setup.py || die
	fi
}

python_test() {
	pytest -vv tests/cover tests/pytest tests/quality ||
		die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pandas support" dev-python/pandas
	optfeature "pytest support" dev-python/pytest
}
