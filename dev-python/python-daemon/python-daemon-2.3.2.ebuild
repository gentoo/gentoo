# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Library to implement a well-behaved Unix daemon process"
HOMEPAGE="
	https://pagure.io/python-daemon/
	https://pypi.org/project/python-daemon/
"

# build system and tests use GPL-3.0+ but none of these files are installed
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	dev-python/lockfile[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
