# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
# TODO: revert to rdepend once this is merged
# https://github.com/openstack/cliff/pull/3
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Command Line Interface Formulation Framework"
HOMEPAGE="https://github.com/openstack/cliff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc64 ~s390 sparc x86"

RDEPEND="
	>=dev-python/autopage-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/cmd2-0.8.0[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/stevedore-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
