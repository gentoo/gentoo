# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="ZConfig"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A configuration library supporting a hierarchical schema-driven configuration model"
HOMEPAGE="https://pypi.python.org/pypi/ZConfig"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/manuel[${PYTHON_USEDEP}]
		dev-python/zope-exceptions[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
		dev-python/zope-testrunner[${PYTHON_USEDEP}]
	)
"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests nose
distutils_enable_sphinx doc dev-python/sphinxcontrib-programoutput
