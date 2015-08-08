# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

FONT_S="${S}"
FONTDIR="/usr/share/fonts/indic"
FONT_SUFFIX="ttf"

DESCRIPTION="The Lohit family of Indic fonts"
HOMEPAGE="https://fedorahosted.org/lohit"
LICENSE="GPL-2"
SRC_URI="https://fedorahosted.org/releases/l/o/lohit/${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE=""

DOCS="AUTHORS ChangeLog README"

RESTRICT="test binchecks"

src_install() {
	FONT_CONF=( $(find "${FONT_S}" -name *.conf -print) )
	find "${S}" -name "*.ttf" -exec cp "{}" . \;
	font_src_install
}
