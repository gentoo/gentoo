# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A collection of Gentoo Linux wallpapers for the LiveCD"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="https://www.gentoo.org/"

KEYWORDS="alpha amd64 ia64 ppc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/pixmaps
	doins -r *
}
