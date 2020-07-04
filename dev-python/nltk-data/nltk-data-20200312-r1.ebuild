# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs

DESCRIPTION="Data files for NLTK"
HOMEPAGE="https://www.nltk.org/nltk_data/"

# at least some of the files have poorly documented licenses
# TODO: create a USE flag for free-ish subset
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="extra"
RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"

PACKAGES_ZIP=(
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

PACKAGES_UNPACK=(
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
	corpora/inaugural
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
	corpora/sinica_treebank
	corpora/state_union
	corpora/stopwords
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
	taggers/universal_tagset
	tokenizers/punkt
)

PACKAGES_UNPACK_EXTRA=(
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

add_data() {
	local x
	for x; do
		SRC_URI+="
			https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/${x}.zip
				-> nltk-${x#*/}-${PV}.zip"
	done
}

add_data "${PACKAGES_ZIP[@]}" "${PACKAGES_UNPACK[@]}"
SRC_URI+="
	extra? ("
add_data "${PACKAGES_UNPACK_EXTRA[@]}"
SRC_URI+="
	)"

CHECKREQS_DISK_USR=3G
CHECKREQS_DISK_BUILD=${CHECKREQS_DISK_USR}

src_unpack() {
	local x
	local to_unpack=( "${PACKAGES_UNPACK[@]}" )
	use extra && to_unpack+=( "${PACKAGES_UNPACK_EXTRA[@]}" )
	for x in "${to_unpack[@]}"; do
		local cat=${x%/*}
		local pkg=${x#*/}

		mkdir -p "${S}/${cat}" || die
		cd "${S}/${cat}" || die
		unpack "nltk-${pkg}-${PV}.zip"
	done
}

src_install() {
	dodir /usr/share/nltk_data
	mv * "${ED}/usr/share/nltk_data/" || die

	local x
	for x in "${PACKAGES_ZIP[@]}"; do
		local cat=${x%/*}
		local pkg=${x#*/}

		insinto "/usr/share/nltk_data/${cat}"
		newins "${DISTDIR}/nltk-${pkg}-${PV}.zip" "${pkg}.zip"
	done
}
