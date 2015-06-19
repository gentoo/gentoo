# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/descent2-demodata/descent2-demodata-1.0.ebuild,v 1.11 2015/02/09 08:17:51 ago Exp $

EAPI=5
inherit eutils games

MY_PN="d2demo"
MY_PV=${PV/./}
DEMO="${MY_PN}${MY_PV}.zip"

DESCRIPTION="Demo data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/product.asp?GameID=109"
SRC_URI="ftp://ftp.funet.fi/pub/msdos/games/interplay/${DEMO}
	ftp://ftp.demon.co.uk/pub/ibmpc/dos/games/descent/${DEMO}
	mirror://3dgamers/descent2/${DEMO}"

# See README.TXT
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

# d2x-0.2.5-r2 may include the demo data itself
# d2x-0.2.5-r3 does not include the demo data
#RDEPEND="|| (
#	games-action/d2x-rebirth
#	>=games-action/d2x-0.2.5-r3 )"
RDEPEND="!<games-action/d2x-0.2.5-r3"
DEPEND="app-arch/unzip
	app-arch/unarj"

S=${WORKDIR}
dir=${GAMES_DATADIR}/d2x

src_unpack() {
	unpack ${A}

	# This is much more fun than simply downloading
	# http://www.icculus.org/d2x/data/d2shar10.tar.gz
	unarj e D2_1.SOW || die
	mv ${MY_PN}.ham{,1}
	unarj e D2_2.SOW || die
	mv ${MY_PN}.ham{,2}
	mv ${MY_PN}.pig{,2}
	unarj e D2_3.SOW || die
	mv ${MY_PN}.pig{,3}

	# From the sows, big porkie pies shall grow
	cat ${MY_PN}.ham{1,2} > ${MY_PN}.ham || die
	cat ${MY_PN}.pig{2,3} > ${MY_PN}.pig || die

	rm *{1,2,3} *.{386,bat,ubn} eregcard.ini
	mkdir controls
	mv *.b50 descent2.* controls
}

src_install() {
	insinto "${dir}"
	# The "controls" directory is not needed, nor the ini files
	doins d2demo.*

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "A client is needed to run the game, e.g. games-action/d2x-xl."
	elog "Not all Descent 2 clients support the demo data."
	echo
}
