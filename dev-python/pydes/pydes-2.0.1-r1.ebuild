# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=pyDes
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of DES and TRIPLE DES"
HOMEPAGE="https://pypi.org/project/pyDes/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
