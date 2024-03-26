# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="Python bindings for simdjson"
HOMEPAGE="
	https://github.com/TkTech/pysimdjson/
	https://pypi.org/project/pysimdjson/
"
SRC_URI="
	https://github.com/TkTech/pysimdjson/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/simdjson-2.0.1:=
	test? ( dev-libs/simdjson[all-impls(-)] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/pysimdjson-6.0.2-system-lib.patch"
)

distutils_enable_tests pytest

src_prepare() {
	# force regen
	rm simdjson/csimdjson.cpp || die
	# unbundle
	rm simdjson/simdjson.cpp || die
	echo "#include_next <simdjson.h>" > simdjson/simdjson.h || die

	distutils-r1_src_prepare

	export BUILD_WITH_CYTHON=1
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o required_plugins=
}
