# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="d2demo"
DEMO="${MY_PN}${PV//.}.zip"

DESCRIPTION="Demo data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/descent.php"
SRC_URI="ftp://ftp.funet.fi/pub/msdos/games/interplay/${DEMO}"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# <d2x-0.2.5-r3 may include the data.
RDEPEND="!<games-action/d2x-0.2.5-r3
	!games-action/descent2-data"

BDEPEND="app-arch/unzip
	app-arch/arj"

S="${WORKDIR}"

src_unpack() {
	default

	mv D2_2.SOW D2_1.S01 || die
	mv D2_3.SOW D2_1.S02 || die
	arj e -v -y -_ D2_1.SOW || die
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
