# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo Utility library"
HOMEPAGE="
	https://opendev.org/openstack/oslo.utils/
	https://github.com/openstack/oslo.utils/
	https://pypi.org/project/oslo.utils/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
"
# qemu needed for qemu-img
BDEPEND="
	>=dev-python/pbr-2.2.0[${PYTHON_USEDEP}]
	test? (
		app-emulation/qemu
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# require eventlet
	rm oslo_utils/tests/test_eventletutils.py || die
}
