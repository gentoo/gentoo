# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 virtualx pypi

DESCRIPTION="An object-oriented GUI library for pyglet"
HOMEPAGE="https://glooey.readthedocs.io/en/latest/"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	dev-python/autoprop[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/vecrec[${PYTHON_USEDEP}]
"
# Indirect dependency via pyglet
BDEPEND="test? ( media-libs/freetype )"

# Requires currently unpackaged Sphinx plug-in autoclasstoc
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
