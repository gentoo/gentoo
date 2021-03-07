# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A pure-Python implementation of HTTP/1.1 inspired by hyper-h2"
HOMEPAGE="https://github.com/python-hyper/h11/ https://pypi.org/project/h11/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

distutils_enable_tests pytest
