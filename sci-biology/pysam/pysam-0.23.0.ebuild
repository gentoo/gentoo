# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python interface for the SAM/BAM sequence alignment and mapping format"
HOMEPAGE="
	https://github.com/pysam-developers/pysam
	https://pypi.org/project/pysam/"
SRC_URI="https://github.com/pysam-developers/pysam/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sci-libs/htslib-1.21*:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		=sci-biology/bcftools-1.21*
		=sci-biology/samtools-1.21*
	)"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# only work with bundled htslib
	'tests/tabix_test.py::TestRemoteFileHTTP'
	'tests/tabix_test.py::TestRemoteFileHTTPWithHeader'

	'tests/AlignedSegment_test.py::TestBaseModifications'
)

python_prepare_all() {

	# unbundle htslib
	export HTSLIB_MODE="external"
	export HTSLIB_INCLUDE_DIR="${ESYSROOT}"/usr/include
	export HTSLIB_LIBRARY_DIR="${ESYSROOT}"/usr/$(get_libdir)
	rm -r htslib || die

	if use test; then
		einfo "Building test data"
		emake -C tests/pysam_data
		emake -C tests/cbcf_data
	fi

	# breaks with parallel build
	# need to avoid dropping .so plugins into
	# build-lib, which breaks tests
	DISTUTILS_ARGS=(
		build_ext
		--inplace
		-j1
	)
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf pysam || die
	epytest
}
