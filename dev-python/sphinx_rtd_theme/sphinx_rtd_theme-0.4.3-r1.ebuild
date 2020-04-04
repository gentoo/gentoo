# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="ReadTheDocs.org theme for Sphinx"
HOMEPAGE="https://github.com/readthedocs/sphinx_rtd_theme"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE=""

PDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${PDEPEND}
		dev-python/readthedocs-sphinx-ext[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
