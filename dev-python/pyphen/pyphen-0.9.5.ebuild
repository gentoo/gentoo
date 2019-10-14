# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python{3_6,3_7,3_8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
PLOCALES="af af_ZA bg bg_BG ca cs cs_CZ da da_DK de de_AT de_CH de_DE el el_GR en en_GB en_Latn_GB en_Latn_US en_US es et et_EE fr gl hr hr_HR hu hu_HU id_ID is it it_IT lt lt_LT lv lv_LV nb nb_NO nl nl_NL nn nn_NO pl pl_PL pt pt_BR pt_Latn_BR pt_Latn_PT pt_PT ro ro_RO ru ru_RU sk sk_SK sl sl_SI sr sr_Latn sv te te_IN uk uk_UA zu zu_ZA"

inherit distutils-r1 l10n

DESCRIPTION="Python module for hyphenation using hunspell dictionaries"
HOMEPAGE="https://github.com/Kozea/Pyphen"
SRC_URI="https://github.com/Kozea/Pyphen/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# some dictionaries are used for testing
REQUIRED_USE="test? ( l10n_en l10n_fr l10n_hu l10n_nl )"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
S="${WORKDIR}/Pyphen-${PV}"

# because of pyphen's ll -> ll_LL symlinking setup
# all entries starting with the 2 letter language code need to be installed
for lang in ${PLOCALES}; do
	if [[ ${#lang} -eq 2 ]]; then
		IUSE+=" l10n_${lang}"
	fi
done

src_prepare() {
	default
	l10n_find_plocales_changes "${S}/pyphen/dictionaries" "hyph_" '.dic'

	# removing dictionary files that are not specified through L10N
	for lang in ${PLOCALES}; do
		if [[ ${#lang} -eq 2 ]] && use !l10n_${lang}; then
			rm pyphen/dictionaries/hyph_${lang}* || \
				die "Removing dictionary file(s) failed"
		fi
	done
}

python_test() {
	pytest -vv test.py || die "Tests fail with ${EPYTHON}"
}
