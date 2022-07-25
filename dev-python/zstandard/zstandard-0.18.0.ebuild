# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

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

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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

distutils_enable_tests unittest

src_prepare() {
	# the C backend is repeatedly broken, so force CFFI instead
	sed -e '/PYTHON_ZSTANDARD_IMPORT_POLICY/s:default:cffi:' \
		-i zstandard/__init__.py || die
	# unreliable, fails on x86
	sed -e 's:test_estimated_compression_context_size:_&:' \
		-i tests/test_data_structures.py || die
	# unbundle zstd
	: > zstd/zstdlib.c || die
	# it does random preprocessing on that, so we can't use #include
	cp "${ESYSROOT}/usr/include/zstd.h" zstd/zstd.h || die
	sed -i -e '/include_dirs/a    libraries=["zstd"],' make_cffi.py || die

	distutils-r1_src_prepare

	DISTUTILS_ARGS=(
		--no-c-backend
	)
}

src_test() {
	rm -r zstandard || die
	distutils-r1_src_test
}
