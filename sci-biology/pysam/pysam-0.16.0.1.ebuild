# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python interface for the SAM/BAM sequence alignment and mapping format"
HOMEPAGE="
	https://github.com/pysam-developers/pysam
	https://pypi.org/project/pysam/"
SRC_URI="https://github.com/pysam-developers/pysam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sci-libs/htslib-1.10*:="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		=sci-biology/bcftools-1.10*
		=sci-biology/samtools-1.10*
	)"

distutils_enable_tests pytest

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# unbundle htslib
	export HTSLIB_MODE="external"
	export HTSLIB_INCLUDE_DIR="${EPREFIX}"/usr/include
	export HTSLIB_LIBRARY_DIR="${EPREFIX}"/usr/$(get_libdir)
	rm -r htslib || die

	# prevent setup.py from adding RPATHs (except $ORIGIN)
	sed -e '/runtime_library_dirs=htslib_library_dirs/d' \
		-i setup.py || die

	eapply "${FILESDIR}"/${PN}-0.16.0.1-fix-tests.patch

	if use test; then
		einfo "Building test data"
		emake -C tests/pysam_data
		emake -C tests/cbcf_data
	fi

	distutils-r1_python_prepare_all
}

python_compile() {
	# breaks with parallel build
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}
