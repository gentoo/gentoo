# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=(python3_{7..9})

inherit distutils-r1 virtualx

DESCRIPTION="An object-oriented GUI library for pyglet"
HOMEPAGE="https://glooey.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
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

BDEPEND="${RDEPEND}"

distutils_enable_sphinx docs

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
