# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Extension to use emoji codes in your Sphinx documentation"
HOMEPAGE="https://pypi.org/project/sphinxemoji/
	https://github.com/sphinx-contrib/emojicodes"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
