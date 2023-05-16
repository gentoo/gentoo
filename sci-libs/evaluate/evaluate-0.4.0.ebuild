# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )
inherit distutils-r1

DESCRIPTION="makes evaluating, comparing models and reporting their performance easier"
HOMEPAGE="
	https://pypi.org/project/evaluate/
	https://github.com/huggingface/evaluate
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyarrow[${PYTHON_USEDEP},parquet]
	dev-python/unidecode[${PYTHON_USEDEP}]
"
BDEPEND="test? (
	sci-libs/jiwer[${PYTHON_USEDEP}]
	sci-libs/seqeval[${PYTHON_USEDEP}]
)"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

distutils_enable_tests pytest

src_prepare() {
	# These require packages not available on gentoo
	rm -r metrics/{bertscore,bleurt,character,charcut_mt,chrf,code_eval} || die
	rm -r metrics/{competition_math,coval,google_bleu,mauve,meteor} || die
	rm -r metrics/{nist_mt,rl_reliability,rouge,sacrebleu,sari} || die
	rm -r metrics/{ter,trec_eval,wiki_split,xtreme_s} || die
	rm -r measurements/word_length || die
	distutils-r1_src_prepare
}
