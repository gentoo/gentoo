# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of utilities for publishing packages on PyPI"
HOMEPAGE="
	https://twine.readthedocs.io/
	https://github.com/pypa/twine/
	https://pypi.org/project/twine/
"
SRC_URI="
	https://github.com/pypa/twine/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-3.6[${PYTHON_USEDEP}]
	>=dev-python/keyring-15.1[${PYTHON_USEDEP}]
	>=dev-python/pkginfo-1.8.1[${PYTHON_USEDEP}]
	>=dev-python/readme-renderer-35.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/rich-12.0.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/jaraco-envs[${PYTHON_USEDEP}]
		dev-python/jaraco-functools[${PYTHON_USEDEP}]
		dev-python/munch[${PYTHON_USEDEP}]
		dev-python/portend[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pypiserver[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# pytest-socket dep relevant only to test_integration, and upstream
	# disables it anyway
	sed -i -e '/--disable-socket/d' pytest.ini || die
	sed -i -e '/--cov/d' pytest.ini || die

	distutils-r1_python_prepare_all
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	local EPYTEST_IGNORE=(
		# Internet
		tests/test_integration.py
	)
	local EPYTEST_DESELECT=(
		# Regression due to deps?
		tests/test_check.py::test_fails_rst_no_content
		# Avoid needing heavy virtualx
		tests/test_auth.py::test_warns_for_empty_password
		# https://github.com/pypa/twine/issues/1116
		'tests/test_package.py::test_pkginfo_returns_no_metadata[unsupported Metadata-Version]'
	)

	local -x COLUMNS=80
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
