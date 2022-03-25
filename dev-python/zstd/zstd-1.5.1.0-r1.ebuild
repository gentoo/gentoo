# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Simple python bindings to Yann Collet ZSTD compression library"
HOMEPAGE="https://github.com/sergey-dryabzhinsky/python-zstd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	app-arch/zstd:=
"
RDEPEND="${DEPEND}
	!<dev-python/zstandard-0.15.2-r1[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_configure() {
	DISTUTILS_ARGS=( --external )

	# for tests
	export ZSTD_EXTERNAL=1
	export VERSION=${PV}
	export PKG_VERSION=${PV}
	export LEGACY=0
}
