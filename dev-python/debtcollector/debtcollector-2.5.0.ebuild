# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python deprecation patterns and strategies that collect technical debt"
HOMEPAGE="
	https://opendev.org/openstack/debtcollector/
	https://github.com/openstack/debtcollector/
	https://pypi.org/project/debtcollector/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/wrapt-1.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
