# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="A Python data analysis library that is optimized for humans instead of machines"
HOMEPAGE="https://github.com/wireservice/agate https://pypi.org/project/agate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.5[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.1[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/leather-0.3.2[${PYTHON_USEDEP}]
"
