# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Parameter and topology file editor and molecular mechanical simulator engine"
HOMEPAGE="https://parmed.github.io/ParmEd/html/index.html"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# disable online tests
	local -x CI=true
	epytest
}
