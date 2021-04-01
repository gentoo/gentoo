# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Zstandard Bindings for Python"
HOMEPAGE="https://pypi.org/project/zstandard/ https://github.com/indygreg/python-zstandard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	app-arch/zstd:="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '>=dev-python/cffi-1.14.0-r2:=[${PYTHON_USEDEP}]' 'python*')
"
BDEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py

src_prepare() {
	# the C backend is repeatedly broken, so force CFFI instead
	sed -e '/PYTHON_ZSTANDARD_IMPORT_POLICY/s:default:cffi:' \
		-i zstandard/__init__.py || die
	# unreliable, fails on x86
	sed -e 's:test_estimated_compression_context_size:_&:' \
		-i tests/test_data_structures.py || die

	distutils-r1_src_prepare

	mydistutilsargs=(
		--no-c-backend
		--system-zstd
	)
}
