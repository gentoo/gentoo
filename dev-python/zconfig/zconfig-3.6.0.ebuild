# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P="ZConfig-${PV}"

DESCRIPTION="Configuration library supporting a hierarchical schema-driven configuration model"
HOMEPAGE="https://pypi.org/project/ZConfig/"
SRC_URI="mirror://pypi/${MY_P:0:1}/ZConfig/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/manuel[${PYTHON_USEDEP}]
		dev-python/zope-exceptions[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
		dev-python/zope-testrunner[${PYTHON_USEDEP}]
	)"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests unittest
distutils_enable_sphinx doc dev-python/sphinxcontrib-programoutput
