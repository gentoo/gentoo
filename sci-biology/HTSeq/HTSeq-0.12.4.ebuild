# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python support for SAM/BAM/Bowtie/FASTA/Q/GFF/GTF files"
HOMEPAGE="https://htseq.readthedocs.io/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/htseq/htseq.git"
else
	SRC_URI="https://github.com/htseq/htseq/archive/release_${PV}.tar.gz -> ${P}.tar.gz"

	S="${WORKDIR}"/htseq-release_${PV}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/swig-3.0.8
	dev-python/cython[${PYTHON_USEDEP}]"
