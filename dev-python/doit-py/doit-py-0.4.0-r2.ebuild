# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="doit tasks for python stuff"
HOMEPAGE="https://pythonhosted.org/doit-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? (
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		app-text/hunspell
	)"
RDEPEND="
	dev-python/configclass[${PYTHON_USEDEP}]"

distutils_enable_sphinx doc
distutils_enable_tests pytest
