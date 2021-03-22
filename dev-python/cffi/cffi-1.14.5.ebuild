# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# DO NOT ADD pypy to PYTHON_COMPAT
# pypy bundles a modified version of cffi. Use python_gen_cond_dep instead.
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Foreign Function Interface for Python calling C code"
HOMEPAGE="https://cffi.readthedocs.io/ https://pypi.org/project/cffi/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libffi:="
RDEPEND="${DEPEND}
	dev-python/pycparser[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

distutils_enable_sphinx doc/source

PATCHES=(
	"${FILESDIR}"/cffi-1.14.0-darwin-no-brew.patch
)

src_prepare() {
	if [[ ${CHOST} == *darwin* ]] ; then
		# Don't obsessively try to find libffi
		sed -i -e "s/.*\-iwithsysroot\/usr\/include\/ffi.*/\tpass/" setup.py || die
	fi
	distutils-r1_src_prepare
}

src_configure() {
	tc-export PKG_CONFIG
}

python_test() {
	"${EPYTHON}" -c "import _cffi_backend as backend" || die
	pytest -x -vv \
		--ignore testing/test_zintegration.py \
		--ignore testing/embedding \
		c/ testing/ \
		|| die "Testing failed with ${EPYTHON}"
}
