# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

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
	>=dev-libs/simdjson-5.1.1:=
	test? ( dev-libs/simdjson[all-impls(-),nan] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	# unbundle
	local PATCHES=(
		"${FILESDIR}/pysimdjson-8.0.0-system-lib.patch"
	)

	rm simdjson/simdjson.cpp || die
	echo "#include_next <simdjson.h>" > simdjson/simdjson.h || die

	distutils-r1_src_prepare
}

python_test() {
	if has_version 'dev-libs/simdjson[nan]'; then
		# tests that fail if simdjson has USE=nan
		local -a EPYTEST_DESELECT=(
			'tests/test_conversion.py::test_eager_validates_entire_document[NaN]'
			'tests/test_conversion.py::test_eager_validates_entire_document[Infinity]'
			'tests/test_conversion.py::test_eager_validates_entire_document[{"a":1,"a":NaN}]'
			'tests/test_conversion.py::test_eager_corpus'
		)
	fi
	epytest -o required_plugins=
}
