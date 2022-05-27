# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="Logging as Storytelling"
HOMEPAGE="https://github.com/ScatterHQ/eliot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/boltons-19.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.11.8[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs/source \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
