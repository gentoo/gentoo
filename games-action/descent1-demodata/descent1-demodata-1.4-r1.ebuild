# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

DEMO="desc${PV//.}sw.exe"

DESCRIPTION="Demo data files for Descent 1"
HOMEPAGE="http://www.interplay.com/games/descent.php"
SRC_URI="http://icculus.org/d2x/data/${DEMO}
	ftp://ftp.funet.fi/pub/msdos/games/interplay/${DEMO}"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!games-action/descent1-data"

DEPEND="app-arch/unzip
	app-arch/unarj"

S="${WORKDIR}"

src_unpack() {
	unpack_zip ${A}

	unarj e DESCENT1.SOW || die
	mv descent.pig{,1} || die
	unarj e DESCENT2.SOW || die
	mv descent.pig{,2} || die

	# From the sows, big porkie pies shall grow
	cat descent.pig{1,2} > descent.pig || die
}

src_install() {
	insinto /usr/share/games/d1x
	doins descent.{hog,pig}
	dodoc *.txt
}

pkg_postinst() {
	elog "A client is needed to run the game, e.g. games-action/dxx-rebirth."
	echo
}
