# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for fonts to cover most needs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+free +latin ms"

LANGS="as bn bo brx doi dz gu hi ja km kn ko kok ks mai ml mr ne or pa
	sa sat sd si syc ta te zh"
for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
done
unset lang LANGS

RDEPEND="media-libs/fontconfig
	free? (
		media-fonts/heuristica
		media-fonts/liberation-fonts
		media-fonts/noto
		media-fonts/noto-emoji
		media-fonts/wqy-microhei
		latin? (
			media-fonts/cantarell
			media-fonts/courier-prime
			media-fonts/dejavu
			media-fonts/droid
			media-fonts/font-bh-ttf
			media-fonts/font-cursor-misc
			media-fonts/hack
			media-fonts/ibm-plex
			media-fonts/open-sans
			media-fonts/quivira
			media-fonts/signika
			media-fonts/source-pro
			media-fonts/tex-gyre
			media-fonts/ubuntu-font-family
			media-fonts/urw-fonts
		)
		l10n_as? ( media-fonts/lohit-assamese )
		l10n_bn? ( media-fonts/lohit-bengali )
		l10n_bo? ( media-fonts/tibetan-machine-font )
		l10n_brx? ( media-fonts/lohit-devanagari )
		l10n_doi? ( media-fonts/lohit-devanagari )
		l10n_dz? ( media-fonts/dzongkha-fonts )
		l10n_gu? ( media-fonts/lohit-gujarati )
		l10n_hi? ( media-fonts/lohit-devanagari )
		l10n_ja? (
			media-fonts/ipaex
			media-fonts/ja-ipafonts
			media-fonts/koruri
			media-fonts/mplus-fonts
			media-fonts/vlgothic
		)
		l10n_km? ( media-fonts/khmer )
		l10n_kn? ( media-fonts/lohit-kannada )
		l10n_ko? (
			media-fonts/nanum
			media-fonts/unfonts
		)
		l10n_kok? ( media-fonts/lohit-devanagari )
		l10n_ks? ( media-fonts/lohit-devanagari )
		l10n_mai? ( media-fonts/lohit-devanagari )
		l10n_ml? ( media-fonts/lohit-malayalam )
		l10n_mr? (
			media-fonts/lohit-devanagari
			media-fonts/lohit-marathi
		)
		l10n_ne? (
			media-fonts/lohit-devanagari
			media-fonts/lohit-nepali
		)
		l10n_or? ( media-fonts/lohit-odia )
		l10n_pa? ( media-fonts/lohit-gurmukhi )
		l10n_sa? ( media-fonts/lohit-devanagari )
		l10n_sat? ( media-fonts/lohit-devanagari )
		l10n_sd? ( media-fonts/lohit-devanagari )
		l10n_si? ( media-fonts/lklug )
		l10n_syc? ( media-fonts/font-misc-meltho )
		l10n_ta? (
			media-fonts/lohit-tamil
			media-fonts/lohit-tamil-classical
		)
		l10n_te? ( media-fonts/lohit-telugu )
		l10n_zh? ( media-fonts/wqy-zenhei )
	)
	ms? (
		media-fonts/corefonts
		media-fonts/croscorefonts
		media-fonts/crosextrafonts-caladea
		media-fonts/crosextrafonts-carlito
		media-fonts/dejavu
		media-fonts/droid
		media-fonts/inconsolata
		media-fonts/open-sans
		media-fonts/paratype
	)"
