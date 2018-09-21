# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="A generic AST to represent Python2 and Python3's Abstract Syntax Tree (AST)"
HOMEPAGE="https://pypi.org/project/gast/"
SRC_URI="https://pypi.io/packages/source/g/gast/gast-0.2.0.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
