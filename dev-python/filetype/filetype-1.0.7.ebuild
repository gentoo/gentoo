# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Small, dependency-free, fast Python package to infer binary file types checking"
HOMEPAGE="https://github.com/h2non/filetype.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~sparc"

PATCHES=( "${FILESDIR}/${P}-examples.patch" )

distutils_enable_tests unittest
