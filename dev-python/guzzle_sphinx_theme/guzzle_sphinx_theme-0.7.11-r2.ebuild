# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx theme used by Guzzle"
HOMEPAGE="https://github.com/guzzle/guzzle_sphinx_theme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
