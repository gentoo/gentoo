# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Freezes a Flask application into a set of static files"
HOMEPAGE="
	https://github.com/Frozen-Flask/Frozen-Flask/
	https://pypi.org/project/Frozen-Flask/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/flask-2.0.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/flask-sphinx-themes
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/Frozen-Flask/Frozen-Flask/commit/d3ef9a7315c1742b1d86c32444f5f07e50fa5fbf
	"${FILESDIR}/${P}-test-install.patch"
)
