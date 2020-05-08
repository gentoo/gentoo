# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: if installing off of the 1.01 cd, need to fetch the
#       quake shareware and use that pak0
# http://linux.omnipotent.net/article.php?article_id=11287
# ftp://ftp.cdrom.com/pub/idgames/idstuff/quake/quake106.zip

EAPI=5
inherit eutils cdrom games

DESCRIPTION="iD Software's Quake 1 ... the data files"
HOMEPAGE="https://www.idsoftware.com/games/quake/quake/"
SRC_URI=""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/lha"
RDEPEND="!games-fps/quake1-demodata[symlink]"

S=${WORKDIR}

src_unpack() {
	export CDROM_NAME_SET=("Existing Install" "Quake CD (1.01)" "Ultimate Quake Collection" "Quake CD (newer)")
	cdrom_get_cds id1:q101_int.1:Setup/ID1:resource.1
	if [[ ${CDROM_SET} == "1" ]] ; then
		echo ">>> Unpacking q101_int.lha to ${PWD}"
		cat "${CDROM_ROOT}"/q101_int.1 "${CDROM_ROOT}"/q101_int.2 > \
			"${S}"/q101_int.exe
		lha xqf "${S}"/q101_int.exe || die
		rm -f q101_int.exe
	elif [[ ${CDROM_SET} == "3" ]] ; then
		echo ">>> Unpacking resource.1 to ${PWD}"
		lha xqf "${CDROM_ROOT}"/resource.1 || die
	fi
}

src_install() {
	insinto "${GAMES_DATADIR}"/quake1/id1
	case ${CDROM_SET} in
		0)  doins "${CDROM_ROOT}"/id1/*
		    dodoc "${CDROM_ROOT}"/*.txt
		    ;;
		1|3)doins id1/*
		    dodoc *.txt
		    ;;
		2)  newins "${CDROM_ROOT}"/Setup/ID1/PAK0.PAK pak0.pak
		    newins "${CDROM_ROOT}"/Setup/ID1/PAK1.PAK pak1.pak
		    dodoc "${CDROM_ROOT}"/Docs/*
		    ;;
	esac
	prepgamesdirs
}
