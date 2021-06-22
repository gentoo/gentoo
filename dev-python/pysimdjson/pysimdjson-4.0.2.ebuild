# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python bindings for simdjson"
HOMEPAGE="https://github.com/TkTech/pysimdjson"
SRC_URI="https://github.com/TkTech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/simdjson:=
"
DEPEND=${RDEPEND}
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pysimdjson-4.0.0-unbundle.patch
)

src_prepare() {
	# benchmarks aren't run
	sed -i -e 's:pytest-benchmark::' setup.cfg || die
	# force regen
	rm simdjson/csimdjson.cpp || die
	# bundled lib :-(
	rm simdjson/simdjson.{cpp,h} || die

	distutils-r1_src_prepare

	export BUILD_WITH_CYTHON=1
	export BUILD_WITH_SYSTEM_LIB=1
}
