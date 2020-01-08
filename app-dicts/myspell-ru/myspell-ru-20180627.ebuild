# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=( ru_RU.{dic,aff} )
MYSPELL_HYPH=( hyph_ru_RU.dic )
MYSPELL_THES=( ru_th_aot.{dat,idx} )

inherit myspell-r2

EXT="extensions"
DICT="russian-dictionary-pack"
MY_PN="dict_pack_ru-aot"
MY_PV="0.4.3"

DESCRIPTION="Russian spellcheck dictionary based on works of AOT group for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/russian-dictionary-pack"
SRC_URI="https://extensions.libreoffice.org/${EXT}/${DICT}/0-4.3/@@download/file/${MY_PN}-${MY_PV//./-}.oxt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux"

src_prepare() {
	default
	mv russian-aot.dic ru_RU.dic || die
	mv russian-aot.aff ru_RU.aff || die
}
