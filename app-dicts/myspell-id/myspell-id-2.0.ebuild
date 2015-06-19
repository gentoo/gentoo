# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-id/myspell-id-2.0.ebuild,v 1.10 2015/02/28 13:30:05 ago Exp $

EAPI=4

MYSPELL_DICT=(
	"id_ID.aff"
	"id_ID.dic"
)

MYSPELL_HYPH=(
	"hyph_id_ID.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Indonesian dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/indonesian-dictionary-kamus-indonesia-by-benitius"
SRC_URI="http://extensions.libreoffice.org/extension-center/indonesian-dictionary-kamus-indonesia-by-benitius/releases/${PV}/id_id.oxt -> ${P}.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
