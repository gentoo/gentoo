# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for fonts to cover most needs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"
IUSE="cjk emoji +latin ms"

LANGS="as bn bo brx doi dz gu hi km kn kok ks mai ml mr ne or pa ru sa sat sd si syc ta te th"
for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
done
unset lang LANGS

RDEPEND="media-fonts/cantarell
	media-fonts/droid
	media-fonts/noto
	media-fonts/oldstandard
	media-fonts/powerline-symbols
	media-fonts/ubuntu-font-family
	media-libs/fontconfig
	|| (
		media-fonts/source-code-pro
		media-fonts/anonymous-pro
		media-fonts/cascadia-code
		media-fonts/fantasque-sans-mono
		media-fonts/fira-code
		media-fonts/fira-mono
		media-fonts/hack
		media-fonts/hermit
		media-fonts/ibm-plex
		media-fonts/inconsolata
		media-fonts/iosevka
		media-fonts/jetbrains-mono
		media-fonts/montecarlo
		media-fonts/roboto
		media-fonts/terminus-font
	)
	cjk? (
		media-fonts/ipaex
		media-fonts/ja-ipafonts
		media-fonts/koruri
		media-fonts/monafont
		media-fonts/nanum
		media-fonts/noto-cjk
		media-fonts/opendesktop-fonts
		media-fonts/shinonome
		media-fonts/source-han-sans
		media-fonts/unfonts
		media-fonts/wqy-microhei
		media-fonts/wqy-zenhei
		|| (
			media-fonts/mikachan-font-otf
			media-fonts/mikachan-font-ttf
		)
	)
	emoji? (
		|| (
			media-fonts/noto-emoji
			media-fonts/joypixels
		)
	)
	l10n_as? ( media-fonts/lohit-assamese )
	l10n_bn? ( media-fonts/lohit-bengali )
	l10n_bo? ( media-fonts/tibetan-machine-font )
	l10n_brx? ( media-fonts/lohit-devanagari )
	l10n_doi? ( media-fonts/lohit-devanagari )
	l10n_dz? ( media-fonts/jomolhari )
	l10n_gu? ( media-fonts/lohit-gujarati )
	l10n_hi? ( media-fonts/lohit-devanagari )
	l10n_km? ( media-fonts/khmer )
	l10n_kn? ( media-fonts/lohit-kannada )
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
	l10n_ru? (
		media-fonts/font-misc-cyrillic
		media-fonts/paratype
		media-fonts/paratype-astra
	)
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
	l10n_th? ( media-fonts/thaifonts-scalable )
	latin? (
		media-fonts/courier-prime
		media-fonts/dejavu
		media-fonts/font-bh-ttf
		media-fonts/font-cursor-misc
		media-fonts/liberation-fonts
		media-fonts/open-sans
		media-fonts/quivira
		media-fonts/signika
		media-fonts/tex-gyre
		media-fonts/ttf-bitstream-vera
		media-fonts/urw-fonts
	)
	ms? (
		media-fonts/corefonts
		media-fonts/croscorefonts
		media-fonts/crosextrafonts-caladea
		media-fonts/crosextrafonts-carlito
	)"
