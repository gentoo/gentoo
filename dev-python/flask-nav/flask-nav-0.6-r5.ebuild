# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Easily create navigation for Flask applications"
HOMEPAGE="https://pythonhosted.org/flask-nav/"
# docs are missing from PyPI tarballs
# https://github.com/mbr/flask-nav/pull/12
SRC_URI="https://github.com/mbr/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/dominate[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/visitor[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/alabaster

PATCHES=(
	# https://github.com/mbr/flask-nav/pull/27
	"${FILESDIR}/${P}-py310.patch"
)
