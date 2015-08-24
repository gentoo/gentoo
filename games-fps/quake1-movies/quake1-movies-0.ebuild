# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils games

DESCRIPTION="a collection of all the greatest Quake movies"
HOMEPAGE="http://www.planetquake.com/cineplex/history.html"
SRC_URI="https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/camper.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/rgb.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/rgb2.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/rgb3_preview.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/ta2.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/op_bays.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/cineplex/artifact.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/blah/blahmov.zip
	https://ftp.se.kde.org/pub/pc/games/idgames2/planetquake/blah/blahouts.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

myunpack() {
	echo ">>> Unpacking $1 to ${PWD}"
	unzip -qoLL "${DISTDIR}"/$1 || die "unpacking $1 failed"
}

src_unpack() {
	cd "${S}"
	einfo "Diary of a Camper ..."
	mkdir id1
	cd id1
	myunpack camper.zip
	mv movies.txt movies-camper.txt

	cd "${S}"
	einfo "Ranger Gone Bad ..."
	cd id1
	myunpack rgb.zip
	mv movies.txt movies-rgb.txt
	myunpack rgb2.zip
	mv movies.txt movies-rgb2.txt
	cd ..
	myunpack rgb3_preview.zip
	rm *.bat
	mkdir ta2
	cd ta2
	myunpack ta2.zip

	cd "${S}"
	einfo "Operation Bayshield ..."
	mkdir op_bays
	cd op_bays
	myunpack op_bays.zip

	cd "${S}"
	einfo "The Artifact ..."
	mkdir artifact
	cd artifact
	myunpack artifact.zip

	cd "${S}"
	einfo "Blahbalicious ..."
	myunpack blahmov.zip
	rm *.bat
	cd blah
	myunpack blahouts.zip

	cd "${S}"
	edos2unix $(find . -name '*.txt' -o -name '*.cfg')
}

src_install() {
	insinto "${GAMES_DATADIR}/quake1"
	doins -r * || die "doins"
	prepgamesdirs
}
