# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Typing stubs for docutils"
HOMEPAGE="https://pypi.org/project/types-docutils/"
SRC_URI="https://files.pythonhosted.org/packages/6a/5c/b231a40dab63d06994a7cacebc1da5011b56711c1a9b25365cdb74c40efb/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
