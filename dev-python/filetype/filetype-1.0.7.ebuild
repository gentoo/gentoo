# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Small, dependency-free, fast Python package to infer binary file types checking"
HOMEPAGE="https://github.com/h2non/filetype.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

PATCHES=( "${FILESDIR}/${P}-examples.patch" )

distutils_enable_tests unittest
