# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="d2demo"
DEMO="${MY_PN}${PV//.}.zip"

DESCRIPTION="Demo data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/descent.php"
SRC_URI="ftp://ftp.funet.fi/pub/msdos/games/interplay/${DEMO}"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# <d2x-0.2.5-r3 may include the data.
RDEPEND="!<games-action/d2x-0.2.5-r3
	!games-action/descent2-data"

DEPEND="app-arch/unzip
	app-arch/unarj"

S="${WORKDIR}"

src_unpack() {
	default

	# This is much more fun than simply downloading
	# http://www.icculus.org/d2x/data/d2shar10.tar.gz
	unarj e D2_1.SOW || die
	mv ${MY_PN}.ham{,1} || die
	unarj e D2_2.SOW || die
	mv ${MY_PN}.ham{,2} || die
	mv ${MY_PN}.pig{,2} || die
	unarj e D2_3.SOW || die
	mv ${MY_PN}.pig{,3} || die

	# From the sows, big porkie pies shall grow
	cat ${MY_PN}.ham{1,2} > ${MY_PN}.ham || die
	cat ${MY_PN}.pig{2,3} > ${MY_PN}.pig || die
}

src_install() {
	insinto /usr/share/games/d2x
	doins *.{ham,hog,pig}
	insinto /usr/share/games/d2x/demos
	doins *.dem
	dodoc *.txt
}

pkg_postinst() {
	elog "A client is needed to run the game, e.g. games-action/dxx-rebirth."
	echo
}
