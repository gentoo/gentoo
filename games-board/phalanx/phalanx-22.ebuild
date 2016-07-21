# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs games

MY_PN="Phalanx"
MY_PV="XXII"
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="A chess engine suitable for beginner and intermediate players"
HOMEPAGE="http://phalanx.sourceforge.net/"
SRC_URI="mirror://sourceforge/phalanx/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	# configure is not used in the project; confs are in Makefile,
	# and here we override them:
	local define="-DGNUFUN" myvar
	for myvar in "PBOOK" "SBOOK" "LEARN" ; do
		define="${define} -D${myvar}_DIR=\"\\\"${GAMES_DATADIR}/${PN}\\\"\""
	done
	emake \
		DEFINES="${define}" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dogamesbin phalanx
	insinto "${GAMES_DATADIR}"/${PN}
	doins pbook.phalanx sbook.phalanx learn.phalanx
	dodoc HISTORY README
	prepgamesdirs
}
