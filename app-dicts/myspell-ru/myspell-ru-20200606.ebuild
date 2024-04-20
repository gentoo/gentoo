# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=( ru_RU.{dic,aff} )
MYSPELL_HYPH=( hyph_ru_RU.dic )
MYSPELL_THES=( th_ru_RU_v2.{dat,idx} )

inherit myspell-r2

EXT="extensions"
DICT="russian-dictionary-pack"
MY_PN="dict_pack_ru-aot"
MY_PV="0.4.5"

DESCRIPTION="Russian spellcheck dictionary based on works of AOT group for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/russian-dictionary-pack"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/48/${MY_PN}-${MY_PV}.oxt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux"

src_prepare() {
	default
	mv russian-aot.dic ru_RU.dic || die
	mv russian-aot.aff ru_RU.aff || die
	mv ru_th_aot.dat th_ru_RU_v2.dat || die
	mv ru_th_aot.idx th_ru_RU_v2.idx || die
}
