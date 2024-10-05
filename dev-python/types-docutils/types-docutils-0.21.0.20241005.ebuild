# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Typing stubs for docutils"
HOMEPAGE="https://pypi.org/project/types-docutils/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
