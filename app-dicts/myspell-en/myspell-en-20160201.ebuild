# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PV="${PV:0:4}.${PV:4:2}.${PV:6:2}"

MYSPELL_DICT=(
	"en_AU.aff"
	"en_AU.dic"
	"en_CA.aff"
	"en_CA.dic"
	"en_GB.aff"
	"en_GB.dic"
	"en_US.aff"
	"en_US.dic"
	"en_ZA.aff"
	"en_ZA.dic"
)

MYSPELL_HYPH=(
	"hyph_en_GB.dic"
)

MYSPELL_THES=(
	"th_en_US_v2.dat"
	"th_en_US_v2.idx"
)

inherit myspell-r2

DESCRIPTION="English dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/english-dictionaries"
SRC_URI="http://extensions.libreoffice.org/extension-center/english-dictionaries/releases/${MY_PV}/dict-en.oxt -> dict-en-${PV}.oxt"

LICENSE="GPL-2 LGPL-2.1 Princeton myspell-en_CA-KevinAtkinson"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
