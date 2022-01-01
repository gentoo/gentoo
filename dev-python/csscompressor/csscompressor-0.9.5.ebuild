# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A python port of YUI CSS Compressor"
HOMEPAGE="
	https://github.com/sprymix/csscompressor
	https://pypi.org/project/csscompressor/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

distutils_enable_tests pytest
