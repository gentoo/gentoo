# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A generic AST to represent Python2 and Python3's Abstract Syntax Tree (AST)"
HOMEPAGE="https://pypi.org/project/gast/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD PSF-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 ~sparc x86"

distutils_enable_tests unittest
