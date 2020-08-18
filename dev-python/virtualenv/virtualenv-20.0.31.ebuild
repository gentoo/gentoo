# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6..9}} pypy3 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/appdirs-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/distlib-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/filelock-3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/contextlib2-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/pathlib2-2.3.3[${PYTHON_USEDEP}]
	' -2)
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-0.12[${PYTHON_USEDEP}]
	' -2 python3_{6,7} pypy3)
	$(python_gen_cond_dep '
		>=dev-python/importlib_resources-1.0[${PYTHON_USEDEP}]
	' -2 python3_6 pypy3)"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/flaky[${PYTHON_USEDEP}]
			>=dev-python/pip-20.0.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-5[${PYTHON_USEDEP}]
			>=dev-python/pytest-freezegun-0.4.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-1.3.4[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		' 'python3*')
	)"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/towncrier

src_prepare() {
	# we don't have xonsh
	rm tests/unit/activation/test_xonsh.py || die
	# require internet
	sed -e 's:test_seed_link_via_app_data:_&:' \
		-i tests/unit/seed/embed/test_boostrap_link_via_app_data.py || die
	# TODO: investigate
	sed -e 's:test_cross_major:_&:' \
		-i tests/unit/create/test_creator.py || die

	distutils-r1_src_prepare
}

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	if ! python_is_python3; then
		ewarn "Tests are skipped on py2, please test externally"
		return
	elif [[ ${EPYTHON} == pypy3 ]]; then
		# TODO: skip with better granularity
		ewarn "Skipping broken tests on pypy3"
		return
	fi

	distutils_install_for_testing

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
