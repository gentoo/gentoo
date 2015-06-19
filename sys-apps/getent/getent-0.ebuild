# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/getent/getent-0.ebuild,v 1.3 2014/11/18 18:28:55 blueness Exp $

EAPI="5"

DESCRIPTION="Script to emulate the behavior of glibc's getent utility"
HOMEPAGE="http://www.uclibc.org/"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI="http://git.uclibc.org/uClibc/plain/extra/scripts/${PN}"
	KEYWORDS=""
	MY_P=${PN}
else
	SRC_URI="http://dev.gentoo.org/~blueness/${PN}/${P}"
	KEYWORDS="amd64 arm ~m68k ~mips ppc ~sh ~sparc x86"
	MY_P=${P}
fi

LICENSE="LGPL-2"
SLOT="0"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc
"

src_unpack() {
	mkdir ${P}
	cp "${DISTDIR}"/${MY_P} ${P}/${PN}
}

src_install() {
	dobin getent
}
