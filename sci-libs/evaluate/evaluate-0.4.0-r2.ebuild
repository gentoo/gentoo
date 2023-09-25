# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )
DISTUTILS_SINGLE_IMPL=1
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
	$(python_gen_cond_dep '
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP},parquet]
		dev-python/unidecode[${PYTHON_USEDEP}]
		sci-libs/transformers[${PYTHON_USEDEP}]
	')
	sci-libs/datasets[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="test? (
	$(python_gen_cond_dep '
		sci-libs/jiwer[${PYTHON_USEDEP}]
		sci-libs/seqeval[${PYTHON_USEDEP}]
	')
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
	rm tests/test_evaluation_suite.py || die
	distutils-r1_src_prepare
}
