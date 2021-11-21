# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A generic AST to represent Python2 and Python3's Abstract Syntax Tree (AST)"
HOMEPAGE="https://pypi.org/project/gast/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86"

BDEPEND="
	test? ( dev-python/astunparse[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest
