# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="OpenStack logging config library, configuration for all openstack projects"
HOMEPAGE="
	https://opendev.org/openstack/oslo.log/
	https://github.com/openstack/oslo.log/
	https://pypi.org/project/oslo.log/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.19.0[${PYTHON_USEDEP}]
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-3.1.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/testtools-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc/source \
	dev-python/openstackdocstheme \
	dev-python/oslo-config

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_IGNORE=(
		# requires eventlet
		oslo_log/tests/unit/test_pipe_mutex.py
	)
	local EPYTEST_DESELECT=(
		# messed up with pytest
		oslo_log/tests/unit/fixture/test_logging_error.py::TestLoggingFixture::test_logging_handle_error
	)

	case ${EPYTHON} in
		python3.1[12])
			# upstream is... *sigh*
			EPYTEST_DESELECT+=(
				oslo_log/tests/unit/test_log.py::LogConfigTestCase::test_log_config_append_invalid
			)
	esac

	epytest
}
