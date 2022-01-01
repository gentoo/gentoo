# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Simple python bindings to Yann Collet ZSTD compression library"
HOMEPAGE="https://github.com/sergey-dryabzhinsky/python-zstd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	app-arch/zstd:=
	!dev-python/zstandard[${PYTHON_USEDEP}]
"
DEPEND=${RDEPEND}

distutils_enable_tests unittest

src_configure() {
	mydistutilsargs=( --external )

	# for tests
	export ZSTD_EXTERNAL=1
	export VERSION=${PV}
	export PKG_VERSION=${PV}
	export LEGACY=0
}
