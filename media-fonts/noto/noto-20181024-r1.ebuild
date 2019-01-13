# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-fonts"

COMMIT="d7af81e614086435102cca95961b141b3530a027"
SRC_URI="https://github.com/googlei18n/noto-fonts/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="brahmi music coptic cuneiform cypriot deseret duployan linear
	+display +symbols runic phagspa pau-cin-hau old-arabian hieroglyphs
	+mono ancient"
IUSE_IL10N=( ar ban bax ber bku blt bn bo bsq bug bya ccp chr cja cmr dv
	eo ff gu he hi hoc hy ii ja jv ka khb km kn ko kv lo mai men mjl ml mn mni
	mww my new nod nqo or osa pa rej sa sat saz sd si so sq srb su syc syl ta
	tbw te th tl ur vai zh-CN zh-TW iu hnn bho eky lep lif lis tbw skr mr
	pa )
for lang in "${IUSE_IL10N[@]}"; do
	IUSE="${IUSE} l10n_${lang}"
done

RDEPEND="l10n_zh-CN? ( media-fonts/noto-cjk )
	l10n_zh-TW? ( media-fonts/noto-cjk )
	l10n_ja? ( media-fonts/noto-cjk )
	l10n_ko? ( media-fonts/noto-cjk )"
RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-fonts-${COMMIT}"

FONT_SUFFIX="ttf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/66-noto-serif.conf"
	"${FILESDIR}/66-noto-mono.conf"
	"${FILESDIR}/66-noto-sans.conf"
)

src_prepare() {
	! use mono && find -iname '*mono*.ttf' -delete
	! use hieroglyphs && find -iname '*hieroglyphs*.ttf' -delete
	! use l10n_pa && find . -iname '*mahajani*.ttf' -delete
	! use l10n_mr && find . -iname '*modi*.ttf' -delete
	! use l10n_skr && find . -iname '*multani*.ttf' -delete
	! use old-arabian && find -iname '*old*arabian*.ttf' -delete
	! use pau-cin-hau && find -iname '*paucinhau*.ttf' -delete
	! use phagspa && find . -iname '*phagspa*.ttf' -delete
	! use runic && find . -iname '*runic*.ttf' -delete
	! use symbols && find . -iname '*symbols*.ttf' -delete
	! use l10n_tbw && find . -iname '*tagbanwa*.ttf' -delete
	! use display && find . -iname '*display*.ttf' -delete
	! use l10n_lis && find . -iname '*lisu*.ttf' -delete
	! use linear && find . -iname '*linear*.ttf' -delete
	! use l10n_lif && find . -iname '*limbu*.ttf' -delete
	! use l10n_lep && find . -iname '*lepcha*.ttf' -delete
	! use l10n_bho && find . -iname '*kaithi*' -delete
	! use l10n_eky && find . -iname '*kayahli*' -delete
	! use brahmi && find . -iname '*brahmi*.ttf' -delete
	! use l10n_iu && find . -iname '*canadianaboriginal*.ttf' -delete
	! use l10n_hnn && find . -iname '*hanunoo*.ttf' -delete
	! use coptic && find . -iname '*coptic*.ttf' -delete
	! use cuneiform && find . -iname '*cuneiform*.ttf' -delete
	! use cypriot && find . -iname '*cypriot*.ttf' -delete
	! use deseret && find . -iname '*deseret*.ttf' -delete
	! use duployan && find . -iname '*duployan*.ttf' -delete
	! use l10n_ar && find . -iname '*arabic*.ttf' -delete
	! use l10n_ff && find . -iname '*adlam*.ttf' -delete
	! use l10n_hy && find . -iname '*armenian*.ttf' -delete
	! use l10n_bax && find . -iname '*bamum*.ttf' -delete
	! use l10n_bsq && find . -iname '*bassavah*.ttf' -delete
	! use l10n_bya && find . -iname '*batak*.ttf' -delete
	! use l10n_bn && find . -iname '*bengali*.ttf' -delete
	! use l10n_bug && find . -iname '*buginese*.ttf' -delete
	! use l10n_bku && find . -iname '*buhid*.ttf' -delete
	! use l10n_sq && find . '(' -iname '*albanian*.ttf' -o \
		-iname '*elbasan*.ttf' ')' -delete
	! use l10n_ccp && find . -iname '*chakma*.ttf' -delete
	! use l10n_cja && find . -iname '*cham*.ttf' -delete
	! use l10n_chr && find . -iname '*cherokee*.ttf' -delete
	! use l10n_ur && find . -iname '*urdu*.ttf' -delete
	! use l10n_pa && find . -iname '*gurmukhi*.ttf' -delete
	! use l10n_he && find . -iname '*hebrew*.ttf' -delete
	! use l10n_jv && find . -iname '*javanese*.ttf' -delete
	! use l10n_kn && find . -iname '*kannada*.ttf' -delete
	! use l10n_km && find . -iname '*khmer*.ttf' -delete
	! use l10n_sd && find . -iname '*khudawadi*.ttf' -delete
	! use l10n_ml && find . -iname '*malayalam*.ttf' -delete
	! use l10n_mni && find . -iname '*meetei*.ttf' -delete
	! use l10n_men && find . -iname '*mende*.ttf' -delete
	! use l10n_mn && find . -iname '*mongolian*.ttf' -delete
	! use l10n_cmr && find . -iname '*mro*.ttf' -delete
	! use l10n_khb && find . -iname '*tail*.ttf' -delete
	! use l10n_new && find . -iname '*newa*.ttf' -delete
	! use l10n_nqo && find . -iname '*nko*.ttf' -delete
	! use l10n_sat && find . -iname '*olchiki*.ttf' -delete
	! use l10n_kv && find . -iname '*oldpermic*.ttf' -delete
	! use l10n_or && find . -iname '*oriya*.ttf' -delete
	! use l10n_osa && find . -iname '*osage*.ttf' -delete
	! use l10n_so && find . -iname '*osmanya*.ttf' -delete
	! use l10n_mww && find . '(' -iname '*pahawhhmong*.ttf' -o \
		-iname '*miao*.ttf' ')' -delete
	! use l10n_rej && find . -iname '*rejang*.ttf' -delete
	! use l10n_saz && find . -iname '*saurashtra*.ttf' -delete
	! use l10n_sa && find . '(' -iname '*sharada*.ttf' -o \
		-iname '*bhaiksuki*.ttf' -o \
		-iname '*kharoshthi*.ttf' -o \
		-iname '*grantha*.ttf' ')' -delete
	! use l10n_eo && find . -iname '*shavian*.ttf' -delete
	! use l10n_si && find . -iname '*sinhala*.ttf' -delete
	! use l10n_srb && find . -iname '*sorasompeng*.ttf' -delete
	! use l10n_su && find . -iname '*sundanese*.ttf' -delete
	! use l10n_syl && find . -iname '*sylotinagri*.ttf' -delete
	! use l10n_syc && find . -iname '*syriac*.ttf' -delete
	! use l10n_tl && find . -iname '*tagalog*.ttf' -delete
	! use l10n_tbw && find . -iname '*tagbanawa*.ttf' -delete
	! use l10n_nod && find . -iname '*taitham*.ttf' -delete
	! use l10n_blt && find . -iname '*taiviet*.ttf' -delete
	! use l10n_mjl && find . -iname '*takri*.ttf' -delete
	! use l10n_ta && find . -iname '*tamil*.ttf' -delete
	! use l10n_dv && find . -iname '*thaana*.ttf' -delete
	! use l10n_th && find . -iname '*thai*.ttf' -delete
	! use l10n_bo && find . -iname '*tibetan*.ttf' -delete
	! use l10n_ber && find . -iname '*tifinagh*.ttf' -delete
	! use l10n_mai && find . -iname '*tirhuta*.ttf' -delete
	! use l10n_vai && find . -iname '*vai*.ttf' -delete
	! use l10n_hoc && find . -iname '*warangciti*.ttf' -delete
	! use l10n_ii && find . -iname '*yi*.ttf' -delete
	! use ancient && find . '(' \
		-iname '*marchen*.ttf' -o \
		-iname '*meroitic*.ttf' -o \
		-iname '*lydian*.ttf' -o \
		-iname '*ahom*.ttf' -o \
		-iname '*lycian*.ttf' -o \
		-iname '*glagolitic*.ttf' -o \
		-iname '*aramaic*.ttf' -o \
		-iname '*hatran*.ttf' -o \
		-iname '*mandaic*.ttf' -o \
		-iname '*palmyrene*.ttf' -o \
		-iname '*avestan*.ttf' -o \
		-iname '*ethiopic*.ttf' -o \
		-iname '*gothic*.ttf' -o \
		-iname '*olditalic*.ttf' -o \
		-iname '*samaritan*.ttf' -o \
		-iname '*oldhungarian*.ttf' -o \
		-iname '*oldturkic*.ttf' -o \
		-iname '*psalterpahlavi*.ttf' -o \
		-iname '*oldpersian*.ttf' -o \
		-iname '*ogham*.ttf' -o \
		-iname '*phoenician*.ttf' -o \
		-iname '*manichaean*.ttf' -o \
		-iname '*ugaritic*.ttf' -o \
		-iname '*carian*.ttf' -o \
		-iname '*inscriptional*.ttf' -o \
		-iname '*nabataean*.ttf' ')' -delete
	! use l10n_ban && find . -iname '*balinese*.ttf' -delete
	! use l10n_hi && find . -iname '*devanagari*.ttf' -delete
	! use l10n_ka && find . -iname '*georgian*.ttf' -delete
	! use l10n_gu && find . -iname '*gujarati*.ttf' -delete
	! use l10n_lo && find . -iname '*lao*.ttf' -delete
	! use l10n_my && find . -iname '*myanmar*.ttf' -delete
	! use l10n_te && find . -iname '*telugu*.ttf' -delete
	! use music && find . -iname '*music*.ttf' -delete
	default
}

src_install() {
	# Don't install in separate subdirs
	FONT_S="${S}/unhinted/" font_src_install
	FONT_S="${S}/hinted/" font_src_install
}
