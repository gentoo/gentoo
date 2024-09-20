# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Pure-Python implementation of SNMP/SMI MIB parsing and conversion library"
HOMEPAGE="
	https://github.com/lextudio/pysmi/
	https://pypi.org/project/pysmi/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~sparc x86"

RDEPEND="
	>=dev-python/jinja-3.1.3[${PYTHON_USEDEP}]
	>=dev-python/ply-3.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pysnmp-5.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO: doc
# distutils_enable_sphinx docs/source dev-python/sphinx-copybutton dev-python/sphinx-sitemap
