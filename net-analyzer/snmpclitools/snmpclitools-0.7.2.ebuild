# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Pure-Python SNMP management tools"
HOMEPAGE="
	https://github.com/lextudio/snmpclitools/
	https://pypi.org/project/snmpclitools/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-python/pysnmp-6.0.0[${PYTHON_USEDEP}]
"

# TODO: doc
#distutils_enable_sphinx docs/source \
#	dev-python/sphinx-copybutton dev-python/sphinx-notfound-page dev-python/sphinx-sitemap
