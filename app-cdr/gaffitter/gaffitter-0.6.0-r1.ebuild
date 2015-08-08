# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

SV="0.1.0"
SCRIPTS="scripts-${SV}"

DESCRIPTION="Genetic Algorithm File Fitter"
HOMEPAGE="http://gaffitter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	scripts? (
	mirror://sourceforge/${PN}/scripts/${SV}/${SCRIPTS}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="scripts"

src_prepare() {
	sed -i  -e "/^INCLUDES\ =.*/d" \
		-e "s/^CXXFLAGS\ =.*/CXXFLAGS\ =\ ${CXXFLAGS} ${LDFLAGS}/" \
		-e "s/^CXX\ =.*/CXX\ =\ $(tc-getCXX)/" src/Makefile || die "sed failed"
	if use scripts; then
		sed -i -re "s:--data((cd)|(dvd)):--data:" "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-k3b || die
	fi
}

src_install() {
	dobin src/gaffitter || die "dobin failed"
	if use scripts; then
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-** || die
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/nautilus/nautilus-* || die
	fi
	dodoc AUTHORS README || die "dodoc failed"
}
