# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Wnn dictionary for librarian"

HOMEPAGE="http://www.tulips.tsukuba.ac.jp/misc/export/cat/ldic/"
SRC_URI="http://www.tulips.tsukuba.ac.jp/misc/export/cat/ldic/ldic-${PV}-wnn.txt"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-i18n/freewnn"

S=${WORKDIR}

src_unpack() {
	return
}

src_compile() {
	/usr/bin/Wnn4/atod lib.dic < "${DISTDIR}/${A}" || die
}

src_install() {
	insinto /usr/lib/wnn/ja_JP/dic/misc
	doins lib.dic
}

pkg_postinst() {
	elog "lib.dic is installed in /usr/lib/wnn/ja_JP/dic/misc."
	elog "You have to edit your wnnenvrc or eggrc to use it."
}
