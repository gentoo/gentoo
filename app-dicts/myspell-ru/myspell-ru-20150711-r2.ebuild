# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=( ru_RU.{dic,aff} )

MYSPELL_HYPH=( hyph_ru_RU.dic )

MYSPELL_THES=( ru_th_aot.{dat,idx} )

inherit myspell-r2

EXT="extensions"
DICT="russian-spellcheck-dictionary.-based-on-works-of-aot-group"
MY_PN="dict_pack_ru-aot"
MY_PV="0.4.0"

DESCRIPTION="Russian spellcheck dictionary based on works of AOT group for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/russian-spellcheck-dictionary.-based-on-works-of-aot-group"
SRC_URI="https://extensions.libreoffice.org/${EXT}/${DICT}/${MY_PV}/@@download/file/${MY_PN}-0-4-0.oxt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd"

src_prepare() {
	default
	mv russian-aot.dic ru_RU.dic
	mv russian-aot.aff ru_RU.aff
}
