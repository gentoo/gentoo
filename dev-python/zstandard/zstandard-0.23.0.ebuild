# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

MY_P=python-zstandard-${PV}
DESCRIPTION="Zstandard Bindings for Python"
HOMEPAGE="
	https://github.com/indygreg/python-zstandard/
	https://pypi.org/project/zstandard/
"
SRC_URI="
	https://github.com/indygreg/python-zstandard/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="
	app-arch/zstd:=
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.14.0-r2:=[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# the C backend is repeatedly broken, so force CFFI instead
	sed -e '/PYTHON_ZSTANDARD_IMPORT_POLICY/s:default:cffi:' \
		-i zstandard/__init__.py || die
	# unbundle zstd
	rm zstd/* || die
	> zstd/zstd.c || die
	# it does random preprocessing on that, so we can't use #include
	local f
	for f in zdict.h zstd.h; do
		cp "${ESYSROOT}/usr/include/${f}" "zstd/${f}" || die
	done
	sed -i -e '/include_dirs/a    libraries=["zstd"],' make_cffi.py || die

	distutils-r1_src_prepare

	DISTUTILS_ARGS=(
		--no-c-backend
	)
}

python_test() {
	local EPYTEST_DESELECT=(
		# unreliable, fails on x86
		tests/test_data_structures.py::TestCompressionParameters::test_estimated_compression_context_size
		# check for bundled zstd version, fails on other system zstd
		tests/test_module_attributes.py::TestModuleAttributes::test_version
	)

	rm -rf zstandard || die
	epytest
}
