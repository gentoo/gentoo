# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

SV="0.1.0"
SCRIPTS="scripts-${SV}"

DESCRIPTION="Genetic Algorithm File Fitter"
HOMEPAGE="http://gaffitter.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	scripts? ( mirror://sourceforge/${PN}/scripts/${SV}/${SCRIPTS}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="scripts"

PATCHES=( "${FILESDIR}"/${PN}-0.6.0-fix-build-system.patch )

src_prepare() {
	default

	if use scripts; then
		sed -i -re "s:--data((cd)|(dvd)):--data:" "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-k3b || die
	fi
}

src_configure() {
	tc-export CXX
}

src_install() {
	dobin src/gaffitter
	einstalldocs

	if use scripts; then
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/gaff-**
		dobin "${WORKDIR}"/${PN}/${SCRIPTS}/nautilus/nautilus-*
	fi
}
