# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Freezes a Flask application into a set of static files"
HOMEPAGE="
	https://github.com/Frozen-Flask/Frozen-Flask/
	https://pypi.org/project/Frozen-Flask/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/flask-sphinx-themes
distutils_enable_tests unittest
