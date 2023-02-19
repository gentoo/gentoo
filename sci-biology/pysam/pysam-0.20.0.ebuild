# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python interface for the SAM/BAM sequence alignment and mapping format"
HOMEPAGE="
	https://github.com/pysam-developers/pysam
	https://pypi.org/project/pysam/"
SRC_URI="https://github.com/pysam-developers/pysam/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sci-libs/htslib-1.16*:="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		=sci-biology/bcftools-1.16*
		=sci-biology/samtools-1.16*
	)"

distutils_enable_tests pytest

DISTUTILS_IN_SOURCE_BUILD=1

EPYTEST_DESELECT=(
	# only work with bundled htslib
	'tests/tabix_test.py::TestRemoteFileHTTP'
	'tests/tabix_test.py::TestRemoteFileHTTPWithHeader'
	# broken test
	# https://github.com/pysam-developers/pysam/issues/1151#issuecomment-1365662253
	'tests/AlignmentFilePileup_test.py::TestPileupObjects::testIteratorOutOfScope'
)

python_prepare_all() {
	# unbundle htslib
	export HTSLIB_MODE="external"
	export HTSLIB_INCLUDE_DIR="${ESYSROOT}"/usr/include
	export HTSLIB_LIBRARY_DIR="${ESYSROOT}"/usr/$(get_libdir)
	rm -r htslib || die

	# prevent setup.py from adding RPATHs (except $ORIGIN)
	sed -e '/runtime_library_dirs=htslib_library_dirs/d' \
		-i setup.py || die

	if use test; then
		einfo "Building test data"
		emake -C tests/pysam_data
		emake -C tests/cbcf_data
	fi

	distutils-r1_python_prepare_all
}

python_compile() {
	# breaks with parallel build
	# need to avoid dropping .so plugins into
	# build-lib, which breaks tests
	esetup.py build_ext --inplace -j1
	distutils-r1_python_compile -j1
}
