# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Easy to use mocking, stubbing and spying framework"
HOMEPAGE="https://github.com/agoragames/chai"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

PATCHES=( "${FILESDIR}"/${P}-drop-Python2.patch )

distutils_enable_tests nose
