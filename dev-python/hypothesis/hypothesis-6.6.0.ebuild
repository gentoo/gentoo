# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 eutils multiprocessing optfeature

DESCRIPTION="A library for property based testing"
HOMEPAGE="https://github.com/HypothesisWorks/hypothesis https://pypi.org/project/hypothesis/"
SRC_URI="https://github.com/HypothesisWorks/${PN}/archive/${PN}-python-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-python-${PV}/${PN}-python"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="cli"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	cli? (
		$(python_gen_cond_dep '
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
		' 'python*')
	)
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		!!<dev-python/typing-3.7.4.1
	)
"

distutils_enable_tests --install pytest

python_prepare() {
	if ! use cli || [[ ${EPYTHON} != python* ]]; then
		sed -i -e '/console_scripts/d' setup.py || die
	fi
}

python_test() {
	distutils_install_for_testing --via-root
	pytest -vv tests/cover tests/pytest tests/quality \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" ||
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
