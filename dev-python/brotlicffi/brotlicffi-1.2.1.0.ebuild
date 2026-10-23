# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )

inherit distutils-r1

# Ideally we'd fetch the git archive for the commit bundled in brotlicffi,
# but upstream is removing various test data files from the git archive.
BROTLI_TESTDATA_PV=1.2.1
DESCRIPTION="Python binding to the Brotli library"
HOMEPAGE="
	https://github.com/python-hyper/brotlicffi/
	https://pypi.org/project/brotlicffi/
"
SRC_URI="
	https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/google/brotli/releases/download/v${BROTLI_TESTDATA_PV}/testdata.txz
			-> brotli-${PV}-testdata.txz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

DEPEND="
	app-arch/brotli:=
"
BDEPEND="
	>=dev-python/cffi-1.17.0[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_RERUNS=5
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# incompatible with USE_SHARED_BROTLI=1
	test/test_compatibility.py::test_brotli_version
)

src_unpack() {
	default
	if use test; then
		mv tests "${S}"/libbrotli/ || die
	fi
}

src_configure() {
	export USE_SHARED_BROTLI=1
}
