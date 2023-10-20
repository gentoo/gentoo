# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="
	https://opendev.org/openstack/cliff/
	https://github.com/openstack/cliff/
	https://pypi.org/project/cliff/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/autopage-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/cmd2-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-4.11.1[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-2.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
