# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Community Bonus Pack for UT2003"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2003"
SRC_URI="https://downloads.unrealadmin.org/UT2003/BonusPack/cbp2003.zip"
S="${WORKDIR}"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="~x86"
# Needs signup to download
RESTRICT="bindist fetch mirror strip"

RDEPEND="games-fps/ut2003"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_unpack() {
	unpack_zip "${DISTDIR}"/${A}
}

src_install() {
	# Inlined from games.eclass
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

	for i in Animations Help Music Maps StaticMeshes Textures System; do
		mkdir -p "${Ddir}"/${i} || die
	done

	_games_umod_unpack CBP2003.ut2mod

	rm "${Ddir}"/Readme.txt "${Ddir}/cbp installer logo1.bmp" || die
}
