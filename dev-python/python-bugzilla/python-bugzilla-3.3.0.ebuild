# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A python module for interacting with Bugzilla over XMLRPC"
HOMEPAGE="
	https://github.com/python-bugzilla/python-bugzilla/
	https://pypi.org/project/python-bugzilla/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	|| (
		dev-python/python-magic[${PYTHON_USEDEP}]
		sys-apps/file[python,${PYTHON_USEDEP}]
	)
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
