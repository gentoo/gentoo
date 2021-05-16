# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="debonus.ut2mod.zip"
DESCRIPTION="Digital Extremes Bonus Pack for UT2003"
HOMEPAGE="https://www.moddb.com/games/unreal-tournament-2003"
SRC_URI="http://ftp.student.utwente.nl/pub/games/UT2003/BonusPack/${MY_P}"
S="${WORKDIR}"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="~x86"
RESTRICT="bindist mirror strip"

RDEPEND="games-fps/ut2003"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_unpack() {
	unzip -qq "${DISTDIR}"/${A} || die
}

src_install() {
	local dir="${EPREFIX}"/opt/ut2003
	local Ddir="${D}${dir}"

	# Inlined from games.eclass
	_games_umod_unpack() {
		local umod=${1}

		mkdir -p "${Ddir}"/System || die
		cp "${dir}"/System/{ucc-bin,Manifest.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int} "${Ddir}"/System || die
		# Don't die here (for now) in case Default.ini, DefUser.ini are missing
		cp "${dir}"/System/Def{ault,User}.ini "${Ddir}"/System &> /dev/null

		cd "${Ddir}"/System || die
		UT_DATA_PATH="${Ddir}"/System ./ucc-bin umodunpack -x "${S}/${umod}" -nohomedir &> /dev/null || die "uncompressing file ${umod}"
		rm -f "${Ddir}"/System/{ucc-bin,{Manifest,Def{ault,User},User,UT200{3,4}}.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int,ucc.log &>/dev/null || die "Removing temporary files"
	}

	mkdir -p "${Ddir}"/{System,Maps,StaticMeshes,Textures,Music,Help} || die

	_games_umod_unpack DEBonus.ut2mod
}
