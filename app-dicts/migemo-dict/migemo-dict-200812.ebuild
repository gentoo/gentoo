# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE="unicode"

DESCRIPTION="Dictionary files for the Migemo and C/Migemo"
HOMEPAGE="http://openlab.ring.gr.jp/skk/dic.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if use unicode ; then
		iconv -f euc-jp -t utf-8 migemo-dict > "${T}/migemo-dict"
	else
		cp migemo-dict "${T}/migemo-dict"
	fi
}

src_install() {
	insinto /usr/share/migemo
	doins "${T}/migemo-dict"
}
