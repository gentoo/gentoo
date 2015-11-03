# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="as bn brx bo doi dz gu hi ja km kn_IN ko kok ks mai ml mr ne or pa_IN
sa_IN sat sd si syc ta te zh"
inherit l10n

DESCRIPTION="Meta package for infinality-ultimate with fonts"
HOMEPAGE="http://bohoomil.com/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal +latin +free ms"

RDEPEND="media-libs/fontconfig-ultimate
	free? (
		media-fonts/noto
		media-fonts/heuristica
		media-fonts/liberation-fonts
		media-fonts/wqy-microhei
		latin? (
			media-fonts/courier-prime
			media-fonts/dejavu
			media-fonts/signika
			media-fonts/symbola
			media-fonts/tex-gyre
			!minimal? (
				media-fonts/cantarell
				media-fonts/droid
				media-fonts/font-bh-ttf
				media-fonts/font-cursor-misc
				media-fonts/open-sans
				media-fonts/source-pro
				media-fonts/ubuntu-font-family
				media-fonts/urw-fonts
			)
		)
		linguas_brx? ( media-fonts/lohit-devanagari )
		linguas_doi? ( media-fonts/lohit-devanagari )
		linguas_dz? ( media-fonts/dzongkha-fonts )
		linguas_hi? ( media-fonts/lohit-devanagari )
		linguas_ja? ( media-fonts/ja-ipafonts )
		linguas_km? ( media-fonts/khmer )
		linguas_ko? ( media-fonts/unfonts )
		linguas_kok? ( media-fonts/lohit-devanagari )
		linguas_ks? ( media-fonts/lohit-devanagari )
		linguas_mai? ( media-fonts/lohit-devanagari )
		linguas_mr? ( media-fonts/lohit-devanagari )
		linguas_ne? ( media-fonts/lohit-devanagari )
		linguas_or? ( media-fonts/lohit-odia )
		linguas_sa_IN? ( media-fonts/lohit-devanagari )
		linguas_sat? ( media-fonts/lohit-devanagari )
		linguas_sd? ( media-fonts/lohit-devanagari )
		linguas_si? ( media-fonts/lklug )
		linguas_syc? ( media-fonts/font-misc-meltho )
		!minimal? (
			linguas_as? ( media-fonts/lohit-assamese )
			linguas_bn? ( media-fonts/lohit-bengali )
			linguas_bo? ( media-fonts/tibetan-machine-font )
			linguas_gu? ( media-fonts/lohit-gujarati )
			linguas_ja? (
				media-fonts/ipaex
				media-fonts/koruri
				media-fonts/mplus-fonts
				media-fonts/vlgothic
			)
			linguas_kn_IN? ( media-fonts/lohit-kannada )
			linguas_ko? ( media-fonts/nanum )
			linguas_ml? ( media-fonts/lohit-malayalam )
			linguas_mr? ( media-fonts/lohit-marathi )
			linguas_ne? ( media-fonts/lohit-nepali )
			linguas_pa_IN? ( media-fonts/lohit-gurmukhi )
			linguas_ta? (
				media-fonts/lohit-tamil
				media-fonts/lohit-tamil-classical
			)
			linguas_te? ( media-fonts/lohit-telugu )
			linguas_zh? ( media-fonts/wqy-zenhei )
		)
	)
	ms? (
		media-fonts/corefonts
		!minimal? (
			media-fonts/dejavu
			media-fonts/droid
			media-fonts/inconsolata
			media-fonts/open-sans
			media-fonts/paratype
		)
	)"
