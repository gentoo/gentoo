# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="
	https://opendev.org/openstack/cliff/
	https://github.com/openstack/cliff/
	https://pypi.org/project/cliff/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/autopage-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/cmd2-0.8.0[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-5.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
