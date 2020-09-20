# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 optfeature

DESCRIPTION="A library for property based testing"
HOMEPAGE="https://github.com/HypothesisWorks/hypothesis https://pypi.org/project/hypothesis/"
SRC_URI="https://github.com/HypothesisWorks/${PN}/archive/${PN}-python-${PV}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86"
RESTRICT="test"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2*' pypy)
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${PN}-python-${PV}/${PN}-python"

src_prepare() {
	# avoid pytest-xdist dep for one test
	sed -i -e 's:test_prints_statistics_given_option_under_xdist:_&:' \
		tests/pytest/test_statistics.py || die
	# broken on py3.9, the code is too awful to debug
	rm tests/py3/test_lookup.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pandas support" dev-python/pandas
	optfeature "pytest support" dev-python/pytest
}
