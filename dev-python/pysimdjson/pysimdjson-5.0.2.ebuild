# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for simdjson"
HOMEPAGE="
	https://github.com/TkTech/pysimdjson/
	https://pypi.org/project/pysimdjson/
"
SRC_URI="
	https://github.com/TkTech/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/simdjson-2.0.1:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# benchmarks aren't run
	sed -i -e 's:pytest-benchmark:: ; /license_file/ d' setup.cfg || die
	# force regen
	rm simdjson/csimdjson.cpp || die
	# unbundle
	> simdjson/simdjson.cpp || die
	echo "#include_next <simdjson.h>" > simdjson/simdjson.h || die

	distutils-r1_src_prepare

	export BUILD_WITH_CYTHON=1
}

python_compile() {
	distutils-r1_python_compile --libraries simdjson
}
