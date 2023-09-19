# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python support for SAM/BAM/Bowtie/FASTA/Q/GFF/GTF files"
HOMEPAGE="https://htseq.readthedocs.io/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/htseq/htseq.git"
else
	SRC_URI="https://github.com/htseq/htseq/archive/release_${PV}.tar.gz -> ${P}.gh.tar.gz"

	S="${WORKDIR}"/htseq-release_${PV}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)"
BDEPEND="
	>=dev-lang/swig-3.0.8
	dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_configure() {
	# mask broken asserts in src/step_vector.h:72
	append-cppflags -DNDEBUG

	distutils-r1_src_configure
}

python_test() {
	distutils_install_for_testing

	# Due to the build directories creating a competing
	# hierarchy, we move to the test/ dir to avoid implicitly
	# injecting the root HTSeq/ dir into the PYTHONPATH,
	# which leads the python module lookup astray:
	#   ${PWD}
	#   ├── build
	#   │   ├── lib
	#   │   │   └── HTSeq
	#   │   [...]
	#   ├── HTSeq
	#   └── test
	cd test/ || die
	ln -s ../example_data || die
	epytest
}
