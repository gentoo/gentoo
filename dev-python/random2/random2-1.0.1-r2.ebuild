# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python-2.7 random module ported to python-3"
HOMEPAGE="https://pypi.org/project/random2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

BDEPEND="app-arch/unzip"

distutils_enable_tests setup.py

PATCHES=( "${FILESDIR}/${P}-py39-tests.patch" )
