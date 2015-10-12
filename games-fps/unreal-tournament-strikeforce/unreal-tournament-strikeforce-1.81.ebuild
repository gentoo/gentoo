# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

MY_PV=${PV/./}
DESCRIPTION="A UT addon where you fight terrorists as part of an elite strikeforce"
HOMEPAGE="http://www.strike-force.com/"
#http://strikeforce.redconcepts.net:8888/sf_180_server_files.tar.gz
SRC_URI="mirror://gentoo/sf_180_server_files.tar.gz
	mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/sf180lnx.zip"
#http://www.hut.fi/~kalyytik/sf/linux-sf.html

LICENSE="unreal-tournament-strikeforce"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="bindist"

RDEPEND="|| (
		games-fps/unreal-tournament
		games-fps/unreal-tournament-goty
	)"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack sf_180_server_files.tar.gz
	unpack ${P}.tar.bz2
	unpack sf180lnx.zip
	mv "README - sf orm mappack.txt" Strikeforce/SFDoc/
	rm -rf Help/OpenGL\ Alternate
	rm System/*.{dll,lnk,exe} System/ServerAdds.zip
	rm Strikeforce/SF_System/*.bat
	find -type f -exec chmod a-x '{}' +
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/unreal-tournament
	dodir "${dir}"
	mv * "${D}/${dir}/"
	prepgamesdirs
}
