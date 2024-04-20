# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

# Commit of the Brotli library bundled within brotlipy.
BROTLI_BUNDLED_COMMIT="ed738e842d2fbdf2d6459e39267a633c4a9b2f5d"

DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="
	https://github.com/python-hyper/brotlicffi/
	https://pypi.org/project/brotlicffi/
"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/google/brotli/archive/${BROTLI_BUNDLED_COMMIT}.tar.gz
			-> brotli-${BROTLI_BUNDLED_COMMIT}.tar.gz
		https://github.com/google/brotli/raw/ed738e842d2fbdf2d6459e39267a633c4a9b2f5d/tests/testdata/alice29.txt
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	app-arch/brotli:=
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# incompatible with USE_SHARED_BROTLI=1
	test/test_compatibility.py::test_brotli_version
)

src_unpack() {
	default
	if use test; then
		mv "brotli-${BROTLI_BUNDLED_COMMIT}"/tests "${S}"/libbrotli/ || die
		# sigh, google and their stupid .gitattributes
		cp "${DISTDIR}"/alice29.txt "${S}"/libbrotli/tests/testdata/ || die
	fi
}

src_configure() {
	export USE_SHARED_BROTLI=1
}
