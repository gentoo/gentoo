# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"hu_HU-${PV}/hu_HU.aff"
	"hu_HU-${PV}/hu_HU.dic"
)

MYSPELL_HYPH=(
	"huhyphn_v20110815_LibO/hyph_hu_HU.dic"
)

MYSPELL_THES=(
	"opt/libreoffice3.6/share/extensions/dict-hu/th_hu_HU_v2.dat"
	"opt/libreoffice3.6/share/extensions/dict-hu/th_hu_HU_v2.idx"
)

inherit rpm myspell-r2

DESCRIPTION="Hungarian dictionaries for myspell/hunspell"
HOMEPAGE="http://magyarispell.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/magyarispell/hu_HU-${PV}.tar.gz
	mirror://sourceforge/magyarispell/huhyphn_v20110815_LibO.tar.gz
	http://downloadarchive.documentfoundation.org/libreoffice/old/3.6.0.4/rpm/x86/LibO_3.6.0.4_Linux_x86_langpack-rpm_hu.tar.gz
"
# Hyphen seems to have no releases but was not updated in last 4 years, just use
# one arived version from libreoffice and be done with it. If it needs update
# users can ope a bug.

LICENSE="GPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

src_unpack() {
	myspell-r2_src_unpack

	rpm_unpack ./LibO_3.6.0.4_Linux_x86_langpack-rpm_hu/RPMS/libreoffice3.6-dict-hu-3.6.0.4-104.i586.rpm
}
