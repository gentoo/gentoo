# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Random ~/.signature generator"
HOMEPAGE="http://www.geekthing.com/~robf/gensig/ChangeLog"
SRC_URI="http://www.geekthing.com/~robf/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_install () {
	make DESTDIR=${D} install || die
}
