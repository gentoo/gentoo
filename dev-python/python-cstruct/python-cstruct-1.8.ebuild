# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="C-style structs for Python"
HOMEPAGE="https://github.com/andreax79/python-cstruct https://pypi.org/project/cstruct/"
SRC_URI="https://github.com/andreax79/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

distutils_enable_tests setup.py
