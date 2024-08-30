# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pure python implementation of IPMI protocol"
HOMEPAGE="
	https://opendev.org/x/pyghmi/
	https://pypi.org/project/pyghmi/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/cryptography-2.1[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
