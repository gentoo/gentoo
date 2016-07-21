# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYSPELL_DICT=( russian-aot.{dic,aff} )

MYSPELL_HYPH=( hyph_ru_RU.dic )

MYSPELL_THES=( ru_th_aot.{dat,idx} )

inherit myspell-r2

EXT="extension-center"
DICT="russian-dictionary-pack"
MY_PN="dict_pack_ru-aot"
MY_PV="0.4.0"

DESCRIPTION="Russian spellcheck dictionary based on works of AOT group for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/russian-dictionary-pack"
SRC_URI="http://extensions.libreoffice.org/${EXT}/${DICT}/releases/${MY_PV}/${MY_PN}-0-4-0.oxt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd"

src_install() {
	myspell-r2_src_install
	dosym /usr/share/hunspell/russian-aot.dic /usr/share/myspell/ru_RU.dic
	dosym /usr/share/hunspell/russian-aot.aff /usr/share/myspell/ru_RU.aff
}
