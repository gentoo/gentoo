# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-pl/myspell-pl-20130306.ebuild,v 1.10 2013/08/07 13:24:07 ago Exp $

EAPI=4

MYSPELL_DICT=(
	"pl_PL.aff"
	"pl_PL.dic"
)

MYSPELL_HYPH=(
	"hyph_pl_PL.dic"
)

MYSPELL_THES=(
	"th_pl_PL_v2.dat"
	"th_pl_PL_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Polish dictionaries for myspell/hunspell"
# dict is bumped every day but nothing changes, RECHECK BEFORE DOING VERSION BUMP!
# hyphen has no website
# thesarus released last in 2k8
HOMEPAGE="
	http://www.sjp.pl/slownik/en/
	http://sourceforge.net/projects/synonimy/
"
SRC_URI="
	http://sjp.pl/slownik/ort/sjp-myspell-pl-${PV}.zip
	http://www.openoffice.org/pl/pliki/hyph_pl_PL.zip -> ${P}-hyph.zip
	mirror://sourceforge/synonimy/OOo2-Thesaurus-1.5.zip -> ${P}-thes.zip
"
LICENSE="CC-SA-1.0 LGPL-3 GPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_unpack() {
	myspell-r2_src_unpack

	# ZIPCEPTION!
	unzip hyph_pl_PL.zip
	unzip pl_PL.zip
}
