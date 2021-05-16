# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

BDEPEND="app-arch/unzip
	app-arch/arj"

S="${WORKDIR}"

src_unpack() {
	unpack_zip ${A}

	mv DESCENT2.SOW DESCENT1.S01 || die
	arj e -v -y -_ DESCENT1.SOW || die
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
