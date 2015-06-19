# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/bashforth/bashforth-0.55.ebuild,v 1.2 2014/08/10 20:28:39 slyfox Exp $

DESCRIPTION="BashForth is a string-threaded Forth interpreter in Bash"
HOMEPAGE="http://www.forthfreak.net/index.cgi?BashForth"
SRC_URI="http://forthfreak.net/bashforth.versions/bashforth_v0.55"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">app-shells/bash-2.04"

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/bashforth_v${PV} ${S}
}

src_install() {
	newbin bashforth_v${PV} bashforth
}
