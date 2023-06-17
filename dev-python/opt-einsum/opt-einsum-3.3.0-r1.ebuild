# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Optimized Einsum: A tensor contraction order optimizer"
HOMEPAGE="https://pypi.org/project/opt-einsum/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
