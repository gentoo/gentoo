# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Typing stubs for gdb"
HOMEPAGE="https://pypi.org/project/types-gdb/"
SRC_URI="https://files.pythonhosted.org/packages/8a/a9/d95bc3268e21b460639806ccb48a5a95526c6018862f1aa852c69bce8f1d/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
