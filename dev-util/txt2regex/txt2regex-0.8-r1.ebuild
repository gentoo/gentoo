# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A Regular Expression wizard that converts human sentences to regexs"
HOMEPAGE="http://txt2regex.sourceforge.net/"
SRC_URI="http://txt2regex.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc sparc x86"
IUSE="nls cjk"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=">=app-shells/bash-2.04"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# See bug 93568
	use nls || epatch "${FILESDIR}"/${P}-disable-nls.patch
	use cjk && sed -i -e 's/\xa4/:+:/g' "${S}"/${P}.sh
}

src_install() {
	einstall DESTDIR="${D}" MANDIR="${D}"/usr/share/man/man1 || die
	dodoc Changelog NEWS README README.japanese TODO || die
	newman txt2regex.man txt2regex.6 || die
}
