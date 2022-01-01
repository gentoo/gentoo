# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 )
inherit distutils-r1

DESCRIPTION="Simple python bindings to Yann Collet ZSTD compression library."
HOMEPAGE="https://github.com/sergey-dryabzhinsky/python-zstd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="app-arch/zstd"
