# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Easily create navigation for Flask applications."
HOMEPAGE="https://pythonhosted.org/flask-nav/"
# docs are missing from PyPI tarballs
# https://github.com/mbr/flask-nav/pull/12
SRC_URI="https://github.com/mbr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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
