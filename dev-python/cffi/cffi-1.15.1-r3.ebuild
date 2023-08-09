# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

# py3.12 support is experimental, expect problems in revdeps
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# DO NOT ADD pypy to PYTHON_COMPAT
# pypy bundles a modified version of cffi. Use python_gen_cond_dep instead.
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="Foreign Function Interface for Python calling C code"
HOMEPAGE="
	https://cffi.readthedocs.io/
	https://pypi.org/project/cffi/
"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-drop-deprecated-py.patch.xz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

# Needs recent libffi for HPPA fixes
DEPEND="
	>=dev-libs/libffi-3.4.4-r1:=
"
# setuptools as a modern distutils provider
RDEPEND="
	${DEPEND}
	dev-python/pycparser[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

distutils_enable_sphinx doc/source
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/cffi-1.14.0-darwin-no-brew.patch
	"${FILESDIR}"/${P}-hppa.patch
	"${FILESDIR}"/${P}-python3.11-tests.patch
	"${WORKDIR}"/${P}-drop-deprecated-py.patch
	"${FILESDIR}"/${P}-py312.patch
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
	local EPYTEST_IGNORE=(
		# these tests call pip
		testing/cffi0/test_zintegration.py
	)
	local EPYTEST_DESELECT=()
	if [[ ${EPYTHON} == python3.12 ]]; then
		EPYTEST_DESELECT+=(
			# TODO: these tests hang
			testing/embedding
		)
	fi

	"${EPYTHON}" -c "import _cffi_backend as backend" || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest c testing
}
