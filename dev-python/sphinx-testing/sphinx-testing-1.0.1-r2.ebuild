# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Testing utility classes and functions for Sphinx extensions"
HOMEPAGE="https://github.com/sphinx-doc/sphinx-testing"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
