# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo i18n library"
HOMEPAGE="
	https://opendev.org/openstack/oslo.i18n/
	https://github.com/openstack/oslo.i18n/
	https://pypi.org/project/oslo.i18n/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
