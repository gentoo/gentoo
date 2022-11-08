# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs

DESCRIPTION="Data files for NLTK"
HOMEPAGE="https://www.nltk.org/nltk_data/"

# at least some of the files have poorly documented licenses
# TODO: create a USE flag for free-ish subset
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="extra"
RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"

# https://github.com/nltk/nltk_data/commits/gh-pages

PACKAGES_ZIP_2020=(
	# wget -O - https://www.nltk.org/nltk_data/ | xml sel -t -m '//package[@unzip=0]' -v @subdir -o "/" -v @id -n - | sort
	corpora/comtrans
	corpora/conll2007
	corpora/jeita
	corpora/knbc
	corpora/machado
	corpora/masc_tagged
	corpora/nombank.1.0
	corpora/panlex_swadesh
	corpora/propbank
	corpora/reuters
	corpora/semcor
	corpora/universal_treebanks_v20
	sentiment/vader_lexicon
	stemmers/snowball_data
)

PACKAGES_UNPACK_2020=(
	# wget -O - https://www.nltk.org/nltk_data/ | xml sel -t -m '//package[@unzip=1]' -v @subdir -o "/" -v @id -n - | sort
	corpora/abc
	corpora/alpino
	corpora/brown
	corpora/cess_cat
	corpora/cess_esp
	corpora/chat80
	corpora/city_database
	corpora/cmudict
	corpora/comparative_sentences
	corpora/conll2000
	corpora/conll2002
	corpora/crubadan
	corpora/dependency_treebank
	corpora/dolch
	corpora/europarl_raw
	corpora/floresta
	corpora/framenet_v15
	corpora/framenet_v17
	corpora/gazetteers
	corpora/genesis
	corpora/gutenberg
	corpora/ieer
	corpora/indian
	corpora/lin_thesaurus
	corpora/mac_morpho
	corpora/movie_reviews
	corpora/mte_teip5
	corpora/names
	corpora/nonbreaking_prefixes
	corpora/nps_chat
	corpora/omw
	corpora/opinion_lexicon
	corpora/pl196x
	corpora/ppattach
	corpora/product_reviews_1
	corpora/product_reviews_2
	corpora/pros_cons
	corpora/ptb
	corpora/qc
	corpora/rte
	corpora/senseval
	corpora/sentence_polarity
	corpora/sentiwordnet
	corpora/shakespeare
	corpora/state_union
	corpora/subjectivity
	corpora/swadesh
	corpora/switchboard
	corpora/timit
	corpora/toolbox
	corpora/treebank
	corpora/twitter_samples
	corpora/udhr
	corpora/udhr2
	corpora/verbnet
	corpora/webtext
	corpora/wordnet
	corpora/wordnet_ic
	corpora/words
	grammars/book_grammars
	grammars/large_grammars
	grammars/sample_grammars
	misc/perluniprops
	models/bllip_wsj_no_aux
	models/moses_sample
	models/wmt15_eval
	models/word2vec_sample
	stemmers/porter_test
	stemmers/rslp
	taggers/averaged_perceptron_tagger
	taggers/averaged_perceptron_tagger_ru
)

PACKAGES_UNPACK_2021_12=(
	corpora/inaugural
	corpora/omw-1.4
	corpora/wordnet2021
	corpora/wordnet31
	corpora/sinica_treebank
)

PACKAGES_UNPACK_2022=(
	corpora/stopwords
	taggers/universal_tagset
)

PACKAGES_UNPACK_2022_11=(
	tokenizers/punkt
)

PACKAGES_UNPACK_EXTRA_2020=(
	chunkers/maxent_ne_chunker
	corpora/biocreative_ppi
	corpora/brown_tei
	corpora/kimmo
	corpora/paradigms
	corpora/pe08
	corpora/pil
	corpora/problem_reports
	corpora/smultron
	corpora/unicode_samples
	corpora/verbnet3
	corpora/ycoe
	grammars/basque_grammars
	grammars/spanish_grammars
	help/tagsets
	misc/mwa_ppdb
	taggers/maxent_treebank_pos_tagger
)

PACKAGES_ZIP_EXTRA_2022=(
	corpora/extended_omw
)

add_data() {
	local x version=${1}
	shift

	for x; do
		SRC_URI+="
			https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/${x}.zip
				-> nltk-${x#*/}-${version}.zip"
	done
}

add_data 20200312 "${PACKAGES_ZIP_2020[@]}" "${PACKAGES_UNPACK_2020[@]}"
add_data 20211221 "${PACKAGES_UNPACK_2021_12[@]}"
add_data 20220704 "${PACKAGES_UNPACK_2022[@]}"
add_data 20221108 "${PACKAGES_UNPACK_2022_11[@]}"
SRC_URI+="
	extra? ("
add_data 20200312 "${PACKAGES_UNPACK_EXTRA_2020[@]}"
add_data 20220704 "${PACKAGES_ZIP_EXTRA_2022[@]}"
SRC_URI+="
	)"

CHECKREQS_DISK_USR=3G
CHECKREQS_DISK_BUILD=${CHECKREQS_DISK_USR}

unpack_data() {
	local x version=${1}
	shift

	for x; do
		local cat=${x%/*}
		local pkg=${x#*/}

		mkdir -p "${S}/${cat}" || die
		cd "${S}/${cat}" || die
		unpack "nltk-${pkg}-${version}.zip"
	done
}

src_unpack() {
	unpack_data 20200312 "${PACKAGES_UNPACK_2020[@]}"
	unpack_data 20211023 "${PACKAGES_UNPACK_2021[@]}"
	unpack_data 20211221 "${PACKAGES_UNPACK_2021_12[@]}"
	unpack_data 20220704 "${PACKAGES_UNPACK_2022[@]}"
	unpack_data 20221108 "${PACKAGES_UNPACK_2022_11[@]}"
	if use extra; then
		unpack_data 20200312 "${PACKAGES_UNPACK_EXTRA_2020[@]}"
	fi
}

install_zips() {
	local x version=${1}
	shift

	for x; do
		local cat=${x%/*}
		local pkg=${x#*/}

		insinto "/usr/share/nltk_data/${cat}"
		newins "${DISTDIR}/nltk-${pkg}-${version}.zip" "${pkg}.zip"
	done
}

src_install() {
	dodir /usr/share/nltk_data
	mv * "${ED}/usr/share/nltk_data/" || die

	install_zips 20200312 "${PACKAGES_ZIP_2020[@]}"
	if use extra; then
		install_zips 20220704 "${PACKAGES_ZIP_EXTRA_2022[@]}"
	fi
}
